module OAuth
  class BaseController < Amber::Controller::Base
    include HeaderHelper
    include ErrorHelper
  end
end
