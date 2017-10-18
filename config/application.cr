require "amber"
require "./initializers/**"
require "../src/models/**"
require "../src/helpers/**"
require "../src/controllers/application_controller"
require "../src/controllers/**"


Amber::Server.configure do |setting|
  # setting.name = "Pineauth web application."
  # setting.port = 80 # Port you wish your app to run
  # setting.log = ::Logger.new(STDOUT)
  # setting.log.level = ::Logger::INFO
end
