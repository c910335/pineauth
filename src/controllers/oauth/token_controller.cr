module OAuth
  class TokenController < ApplicationController
    before_action do
      all { response.content_type = "application/json" }
    end

    property! grant : Grant
    property! client : Client
    property! grant_type : String
    getter basic_auth_user : String?
    getter basic_auth_pass : String?

    macro if_client
      if authenticate_basic! && (@client = Client.authenticate(basic_auth_user, basic_auth_pass))
        if (@grant_type = params["grant_type"]?) && ["authorization_code", "refresh_token"].includes? grant_type
          {{yield}}
        else
          error :unsupported_grant_type
        end
      else
        error :invalid_client
      end
    end

    macro if_grant
      if (@grant = Grant.find_by :code, params["code"]?) && grant.authorize client
        if (redirect_uri = params["redirect_uri"]?) && redirect_uri != client.redirect_uri
          error :invalid_request
        else
          {{yield}}
        end
      else
        error :invalid_grant
      end
    end

    def create
      if_client do
        if_grant do
          case grant_type
          when "authorization_code"
            respond_token
          when "refresh_token"
            refresh_and_respond_token
          else
            error :server_error
          end
        end
      end
    end

    private def respond_token
      token = AccessToken.new
      token.scopes = grant.scopes
      token.user_id = grant.user_id
      token.client_id = grant.client_id

      if token.valid? && token.save
        token.to_json
      else
        error :server_error
      end
    end

    private def refresh_and_respond_token
      "" # Todo
    end

    private def error(type : Symbol)
      {
        error:             type.to_s,
        error_description: "Something went wrong.",
      }.to_json
    end

    private def authenticate_basic!
      if (authorization = request.headers["Authorization"]?) &&
         (basic_token = authorization[/Basic (.*)$/, 1]?) &&
         (basic_string = Base64.decode_string(basic_token))
        @basic_auth_user, @basic_auth_pass = basic_string.split(":")
        @basic_auth_user && @basic_auth_pass && true
      end
    end
  end
end
