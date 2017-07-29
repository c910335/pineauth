class ApplicationController < Amber::Controller::Base
  LAYOUT = "application.slang"

  @current_user : User?

  macro if_user
    if user = current_user
      {{yield}}
    else
      ""
    end
  end

  private def root_url
    "/"
  end

  private def current_user
    @current_user ||= if current_user_id = session[:current_user_id]
                        User.find current_user_id
                      end
  end

  private def owner?
    if user = current_user
      user.owner
    end
  end

  private def authenticate_user!
    if user = current_user
      user
    else
      redirect_to root_url
    end
  end
  
  private def authenticate_owner!
    if owner? && (user = current_user)
      user
    else
      redirect_to root_url
    end
  end
end

