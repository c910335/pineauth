module OAuth
  class AuthorizationController < ApplicationController
    LAYOUT = "authorization.slang"

    before_action do
      all do
        authenticate_user_and_return_back!
        set_properties
        halt!(400, error) if error?
      end
    end

    property! client : Client
    property! redirect_uri : String
    property! response_type : String
    property! scopes_string : String
    property! scopes : Array(String)
    property! state : String
    property! error : String

    def new
      render("src/views/oauth/authorization/new.slang")
    end

    def create
      case response_type
      when "code"
        respond_code
      when "token"
        respond_token
      else
        error :server_error
      end
    end

    def destroy
      response.status_code = 501
      "Not Implemented"
    end

    def respond_code
      grant = Grant.new(scopes: scopes_string, client_id: client.id, user_id: current_user.id)

      if grant.valid? && grant.save
        redirect_to redirect_uri, params: code_query_params(grant)
      else
        error :server_error
      end
    end

    def respond_token
      token = AccessToken.new(scopes: scopes_string, client_id: client.id, user_id: current_user.id)

      if token.valid? && token.save
        redirect_to redirect_uri + "#" + token_fragment(token)
      else
        error :server_error
      end
    end

    private def code_query_params(grant)
      qp = {} of String => String
      qp["code"] = grant.code.to_s
      qp["state"] = state if state?
      qp
    end

    private def token_fragment(token)
      f = {
        "access_token" => token.token.to_s,
        "expires_in"   => token.expires_in.to_s,
        "scope"        => token.scopes.to_s,
      }
      f["state"] = state.to_s if state?
      HTTP::Params.encode(f)
    end

    private def set_properties
      return error :invalid_request unless @client = Client.find_by :uid, params["client_id"]?
      return error :invalid_request if (@redirect_uri = params["redirect_uri"]?) && redirect_uri != client.redirect_uri
      @redirect_uri = client.redirect_uri.not_nil!
      return error :unsupported_response_type unless (@response_type = params["response_type"]?) && ["code", "token"].includes? response_type
      return error :invalid_scope unless (@scopes_string = params["scope"]?) && (@scopes = scopes_string.split) && (scopes - client.split_scopes).empty?
      @state = params["state"]?
    end

    private def error(type : Symbol)
      response.content_type = "application/json"
      @error = {
        error:             type.to_s,
        error_description: "Something went wrong.",
      }.to_json # Todo
    end
  end
end
