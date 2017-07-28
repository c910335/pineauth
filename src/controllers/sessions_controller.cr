class SessionsController < ApplicationController 

  def new
    render("new.slang")
  end

  def create
    if user = User.authenticate(params["email"], params["password"])
      if id = user.id
        session[:current_user_id] = id.to_s
        flash[:info] = "Signed in."
      end
    else
      flash[:danger] = "Failed to sign in."
    end
    redirect_to root_url
  end

  def destroy
    session.destroy
    flash[:info] = "You have successfully signed out."
    redirect_to root_url
  end
end
