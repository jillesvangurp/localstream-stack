require 'java'

# loads the java classes either from the maven target directory in backend or the production location in /opt/localstream/lib

targetDir = Dir["target/lib/*.jar"]
# manually load the classpath
if targetDir.length > 0
  puts "using jars from target"
  # development
  targetDir.each { |jar| 
    require jar 
  }
  require 'target/localstream-example-1.0-SNAPSHOT.jar'
else
  # production
  if Dir["/opt/localstream/lib/*.jar"].length > 0
    puts "using jars from /opt/localstream/lib"
    Dir["/opt/localstream/lib/*.jar"].each { |jar| require jar }
  else
    puts "No jars found. Maybe you should do a maven clean install?"
  end
end