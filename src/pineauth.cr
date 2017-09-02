require "amber"
require "granite_orm"
require "../config/**"
require "./models/**"
require "./mailers/**"
require "./helpers/**"
require "./controllers/application_controller"
require "./controllers/**"

Amber::Server.instance.run
