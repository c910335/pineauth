class ApplicationController < Amber::Controller::Base
  LAYOUT = "application.slang"

  include ApplicationHelper
  include ErrorHelper
end
