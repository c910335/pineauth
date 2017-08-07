require "./error_helper"

module ApplicationHelper
  include ErrorHelper

  @current_user : User?

  macro root_path
    "/"
  end

  macro sign_in_path
    "/sign_in"
  end

  private def current_user?
    @current_user ||= if current_user_id = session[:current_user_id]
                        User.find current_user_id
                      end
  end

  private def current_user
    current_user?.not_nil!
  end

  private def owner?
    current_user? && current_user.owner
  end

  private def redirect_to_sign_in(return_back : Bool = false)
    session[:return_to] = if return_back
                            request.resource
                          else
                            root_path
                          end
    error redirect_to sign_in_path
    nil
  end

  private def authenticate_user!(return_back : Bool = false)
    if current_user?
      current_user
    else
      redirect_to_sign_in return_back
    end
  end

  private def authenticate_user_and_return_back!
    authenticate_user! true
  end

  private def authenticate_owner!
    if owner?
      current_user
    else
      redirect_to_sign_in
    end
  end
end
