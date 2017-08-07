require "amber"
require "../config/*"
require "./models/**"
require "./mailers/**"
require "./helpers/**"
require "./controllers/application_controller"
require "./controllers/**"

Amber::Server.instance.run
