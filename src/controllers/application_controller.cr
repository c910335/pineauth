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

  macro root_path
    "/"
  end

  macro sign_in_path
    "/sign_in"
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

  private def authenticate_user!(return_back : Bool = false)
    if user = current_user
      user
    else
      session[:return_to] = if return_back
                              request.resource
                            else
                              root_path
                            end
      redirect_to sign_in_path
    end
  end

  private def authenticate_user_and_return_back!
    authenticate_user! true
  end

  private def authenticate_owner!
    if (user = current_user) && owner?
      user
    else
      session[:return_to] = root_path
      redirect_to sign_in_path
    end
  end
end
