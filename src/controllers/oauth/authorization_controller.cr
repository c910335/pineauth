module OAuth
  class AuthorizationController < ApplicationController
    LAYOUT = "authorization.slang"

    before_action do
      all { authenticate_user_and_return_back! }
    end

    macro if_client
      if client = Client.find_by :uid, params["client_id"]?
        if (redirect_uri = params["redirect_uri"]?) && redirect_uri != client.redirect_uri
          error :not_found
        else
          redirect_uri = client.redirect_uri.not_nil!
          if (response_type = params["response_type"]?) && ["code", "token"].includes? response_type
            if (scopes_string = params["scope"]?) && (scopes = scopes_string.split) && (scopes - client.split_scopes).empty?
              state = params["state"]?
              {{yield}}
            else
              error :invalid_scope
            end
          else
            error :unsupported_response_type
          end
        end
      else
        error :not_found
      end
    end

    def new
      if_client do
        render("src/views/oauth/authorization/new.slang")
      end
    end

    def create
      if_client do
        case response_type
        when "code"
          respond_code
        when "token"
          respond_token
        else
          error :server_error
        end
      end
    end

    macro respond_code
      grant = Grant.new(scopes: scopes_string)
      grant.client_id = client.id
      grant.user_id = current_user!.id

      if grant.valid? && grant.save
        redirect_to redirect_uri, 302, query_params
      else
        error :server_error
      end
    end

    macro respond_token
      "" # Todo
    end

    private def error(type : Symbol)
      response.content_type = "application/json"
      {
        error:             type.to_s,
        error_description: "Something went wrong.",
      }.to_json # Todo
    end

    macro query_params
      qp = {} of String => String
      if code = grant.code
        qp["code"] = code
      end
      if state
        qp["state"] = state
      end
      qp
    end
  end
end
