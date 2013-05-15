require 'lib/enable_java'
require 'sinatra'
require 'json'
require 'docdsl'
require 'lib/app_definition'
require 'jsonj'

class TestApp < Sinatra::Base
  
  register Sinatra::DocDsl 
    
  page do      
    title "Localstream Stack Hello World"
    header "Hello World"
    introduction "This sinatra controller uses a spring service to say hello world. A bit convoluted but it gets the job done."
    footer 'Generated using <a href="https://github.com/jillesvangurp/sinatra-docdsl">sinatra-docdsl</a>.<br/><a href="/api">back</a><br/>Copyright <a href="http://localstre.am">LocalStream</a> 2013'
  end

  # set up logging to use slf4j->logback, amazingly fishwife, sinatra, and rack conspire to override your logging settings
  @@logger = RJack::SLF4J[ "com.localstream.samplelogger" ]
  @@logger.warn('test logger enabled, you should not see this when running fishwife')
  
  helpers do      
    def logger
      @@logger
    end
  end  
  
  include ApplicationDefinition
  @@service=@@ctx.helloWorldService
  
  # API documentation is generated under /doc
  documentation 'Returns whatever object @@ctx.helloWrldRuby returns'
  get '/' do 
    logger.info('yay we got something to do')
    [200, @@ctx.helloWrldRuby]
  end
  
  documentation 'Greets whatever name is specified in the url using the spring service' do
    param :name, 'the name you want to say hi to'
  end  
  get '/:name' do | name |
    [200, @@service.sayHi(name).prettyPrint]
  end
end