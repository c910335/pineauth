require "jasper_helpers"

class ApplicationController < Amber::Controller::Base
  include JasperHelpers
  include ApplicationHelper
  LAYOUT = "application.slang"
end
