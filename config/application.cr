require "amber"
require "crinder"
require "./initializers/**"
require "../src/models/**"
require "../src/renderers/**"
require "../src/helpers/**"
require "../src/controllers/application_controller"
require "../src/controllers/**"

Amber::Server.configure do |settings|
  # settings.name = "Pineauth web application."
  # settings.port = 80 # Port you wish your app to run
  # settings.log = ::Logger.new(STDOUT)
  # settings.log.level = ::Logger::INFO
end
