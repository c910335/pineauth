module OAuth
  class TokenController < ApplicationController
    before_action do
      all do
        response.content_type = "application/json"
        set_properties
      end
    end

    property! grant : Grant
    property! client : Client
    property! grant_type : String
    property! error : String
    getter basic_auth_user : String?
    getter basic_auth_pass : String?

    def create
      return error if error?
      case grant_type
      when "authorization_code"
        respond_token
      when "refresh_token"
        refresh_and_respond_token
      else
        error :server_error
      end
    end

    private def respond_token
      token = AccessToken.new
      token.scopes = grant.scopes
      token.user_id = grant.user_id
      token.client_id = grant.client_id

      if token.valid? && token.save
        grant.revoke
        token.to_json
      else
        error :server_error
      end
    end

    private def refresh_and_respond_token
      "" # Todo
    end

    private def set_properties
      return error :invalid_client unless set_basic_authentication && (@client = Client.authenticate(basic_auth_user, basic_auth_pass))
      return error :unsupported_grant_type unless (@grant_type = params["grant_type"]?) && ["authorization_code", "refresh_token"].includes? grant_type
      return error :invalid_grant unless (@grant = Grant.find_by :code, params["code"]?) && grant.authorize client
      return error :invalid_request if (redirect_uri = params["redirect_uri"]?) && redirect_uri != client.redirect_uri
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
