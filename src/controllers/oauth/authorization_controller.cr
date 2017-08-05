module OAuth
  class AuthorizationController < ApplicationController
    LAYOUT = "authorization.slang"

    before_action do
      all { authenticate_user_and_return_back! && set_properties }
    end

    property! client : Client
    property! redirect_uri : String
    property! response_type : String
    property! scopes_string : String
    property! scopes : Array(String)
    property! state : String
    property! grant : Grant
    property! error : String

    def new
      return error if error?
      render("src/views/oauth/authorization/new.slang")
    end

    def create
      return error if error?
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
      @grant = Grant.new(scopes: scopes_string)
      grant.client_id = client.id
      grant.user_id = current_user.id

      if grant.valid? && grant.save
        redirect_to redirect_uri, 302, query_params
      else
        error :server_error
      end
    end

    def respond_token
      response.status_code = 501
      "Not Implemented"
    end

    private def query_params
      qp = {} of String => String
      qp["code"] = grant.code.not_nil!
      if state?
        qp["state"] = state
      end
      qp
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
