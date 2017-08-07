module OAuth
  class AuthorizedApplicationController < ApplicationController
    before_action do
      all { authenticate_user! }
    end

    def index
      return error if error?
      clients = Client.all("INNER JOIN oauth_grants ON oauth_grants.client_id = oauth_clients.id WHERE oauth_grants.user_id = $1 GROUP BY oauth_clients.id", [current_user.id])
      render("src/views/oauth/authorized_application/index.slang")
    end

    def show
      return error if error?
      if client = Client.all("INNER JOIN oauth_grants ON oauth_grants.client_id = oauth_clients.id WHERE oauth_clients.id = $1 and oauth_grants.user_id = $2", [params["id"], current_user.id]).first
        render("src/views/oauth/authorized_application/show.slang")
      else
        flash["warning"] = "Authorized Application with ID #{params["id"]} Not Found"
        redirect_to "/oauth/authorized_applications"
      end
    end

    def destroy
      return error if error?
      if (grants = Grant.all("WHERE client_id = $1 and user_id = $2", [params["id"], current_user.id])) && !grants.empty?
        grants.each &.destroy
        if tokens = AccessToken.all("WHERE client_id = $1 and user_id = $2 and revoked_at IS NULL", [params["id"], current_user.id])
          tokens.each &.revoke
        end
      else
        flash["warning"] = "Authorized Application with ID #{params["id"]} Not Found"
      end
      redirect_to "/oauth/authorized_applications"
    end
  end
end
