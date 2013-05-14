require 'lib/app_context'
require 'properties_configuration'

#  based on DIY dependency injection framework. We have a container in the form of @@ctx and a 
# initialization routine that executes once that wires up and registers our components. 
# after that, just get from the context what you need.
# Simply include ApplicationDefinition
module ApplicationDefinition  
  @@initialized=false
  @@ctx=AppContext.instance
  
  # make sure we only do this once
  if !@@initialized
    @@ctx.register(:helloWrldRuby, "Hello World")
    
    # load our configuration with some defaults and override locations
    config=PropertiesConfiguration::loadConfiguration({
      :base_uri => 'http://localhost:9292',
    },['/etc/localstream/localstream.properties'])
    
    # make the config part of the application context
    @@ctx.register(:config, config)
    @@initialized=true
  end
end