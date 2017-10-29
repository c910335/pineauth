module OAuth
  class AuthorizedApplicationController < ApplicationController
    before_action do
      all { authenticate_user! }
    end

    def index
      return error if error?
      authorized_applications = AuthorizedApplication.where(user_id: current_user.id, includes: :client)
      render("src/views/oauth/authorized_application/index.slang")
    end

    def show
      return error if error?
      if authorized_application = AuthorizedApplication.find_by(user_id: current_user.id, id: params["id"])
        render("src/views/oauth/authorized_application/show.slang")
      else
        flash["warning"] = "Authorized Application with ID #{params["id"]} Not Found"
        redirect_to "/oauth/authorized_applications"
      end
    end

    def destroy
      return error if error?
      if authorized_application = AuthorizedApplication.find_by(user_id: current_user.id, id: params["id"])
        authorized_application.destroy
      else
        flash["warning"] = "Authorized Application with ID #{params["id"]} Not Found"
      end
      redirect_to "/oauth/authorized_applications"
    end
  end
end
