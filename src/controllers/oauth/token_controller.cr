module OAuth
  class TokenController < BaseController
    before_action do
      all do
        response.content_type = "application/json"
        set_properties
      end
    end

    property! grant : Grant
    property! client : Client
    property! grant_type : String
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
      response.status_code = 501
      "Not Implemented"
    end

    private def set_properties
      return error :invalid_client unless set_basic_authentication && (@client = Client.authenticate(basic_auth_user, basic_auth_pass))
      return error :unsupported_grant_type unless (@grant_type = params["grant_type"]?) && ["authorization_code", "refresh_token"].includes? grant_type
      return error :invalid_grant unless (@grant = Grant.find_by :code, params["code"]?) && grant.authorize client
      return error :invalid_request if (redirect_uri = params["redirect_uri"]?) && redirect_uri != client.redirect_uri
    end
  end
end
