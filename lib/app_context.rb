require 'lib/enable_java'
require 'singleton'

# A Java class that creates the Spring context and exposes it as a singleton
import com.localstream.example.SpringContextLoader

# Simple DIY dependency injection context that mixes spring beans with ruby service objects
# Typically, you create and configure the AppContext once. A useful pattern is to do this 
# in a ruby module that you include everywhere you need to access registered objects. In the 
# module you can use a simple if to check if initialization has been run already.
#
# For example
#
# module ApplicationDefinition  
#   @@initialized=false
#   @@ctx=AppContext.instance
#   
#   # make sure we only do this once
#   if !@@initialized
#     @@ctx.register(:myname, someobject)
#     @@initialized=true
#   end
# end
class AppContext
  include Singleton

  class FeatureFlags
    def initialize()
      @fflags={}
    end
    
    # Lookup a feature flag
    #
    # all flags are false by default and have to be enabled explicitly at run time; for example spec_helper is a good place to enable test flags
    # typically, you initialize feature flags in some central place. For example the place where you are configuring the AppContext.
    def [](key)
      result = @fflags[key]
      if(result)
        result
      else
        false   
      end     
    end
    
    def []= (key,value)      
      @fflags[key]=value
    end
  end

  attr_accessor :context,:beans,:featureFlags
  
  def initialize()
    # make accessing the spring context easy by mapping beans to fields in the singleton class below
    # simply get a reference to the context like this:
    # ctx = AppContext.instance
    #
    # After that, you can simply access the beans using ctx.<beanName>
    @beans={}
    @context=SpringContextLoader.context()
    
    @context.getBeanDefinitionNames.each {|name|
      # add all beans with a valid name
      if not name.include?('.') 
        self.register(name,@context.getBean(name))
      end           
    }    
    self.register('flags',FeatureFlags.new)  
  end
  
  # Register an object with a particular name as an instance variable + accessor with the same name.
  # @returns true if the name is not in use and the object could be registered; false otherwise
  def register(name,object)    
    if ! @beans.include? name
      instance_variable_set( "@" + name.to_s, object)
      self.class.send( :define_method, name.to_sym) { 
        instance_variable_get( "@" + name.to_s )
      }
      @beans[name.to_s]=object
      true
    else
      false
    end
  end    
end