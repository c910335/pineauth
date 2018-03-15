module OAuth
  class TokenInfoController < BaseController
    before_action do
      all do
        response.content_type = "application/json"
        set_bearer_authentication
      end
    end

    property! token : AccessToken

    def show
      if token? && token.accessible?
        AccessTokenInfoRenderer.render token
      else
        error :invalid_request
      end
    end
  end
end
