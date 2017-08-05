module OAuth
  class BaseController < Amber::Controller::Base
    property! token : AccessToken
    property! error : String

    def set_bearer_authentication
      (authorization = request.headers["Authorization"]?) &&
        (token_string = authorization[/Bearer (.*)$/, 1]?) &&
        (@token = AccessToken.find_by :token, token_string) &&
        true
    end

    private def set_basic_authentication
      if (authorization = request.headers["Authorization"]?) &&
         (basic_token = authorization[/Basic (.*)$/, 1]?) &&
         (basic_string = Base64.decode_string(basic_token))
        @basic_auth_user, @basic_auth_pass = basic_string.split(":")
        @basic_auth_user && @basic_auth_pass && true
      end
    end

    private def error(type : Symbol)
      @error = {
        error:             type.to_s,
        error_description: "Something went wrong.",
      }.to_json
    end
  end
end
