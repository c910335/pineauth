module ApplicationHelper
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

  private def redirect_to_sign_in(return_back : Bool = false)
    session[:return_to] = if return_back
                            request.resource
                          else
                            root_path
                          end
    redirect_to sign_in_path
    nil
  end

  {% for name in %w{user developer owner} %}
    private def {{name.id}}?
      current_user? && current_user.{{name.id}}?
    end

    private def authenticate_{{name.id}}!(return_back : Bool = false)
      if {{name.id}}?
        current_user
      else
        redirect_to_sign_in return_back
      end
    end

    private def authenticate_{{name.id}}_and_return_back!
      authenticate_{{name.id}}! true
    end
  {% end %}
end
