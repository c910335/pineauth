class SessionController < ApplicationController
  def new
    render("new.slang")
  end

  def create
    if user = User.authenticate(params["email"], params["password"])
      session[:current_user_id] = user.id
      flash[:info] = "Signed in."
    else
      flash[:danger] = "Failed to sign in."
    end
    if return_to = session[:return_to]
      redirect_to return_to
    else
      redirect_to root_path
    end
  end

  def destroy
    session.destroy
    flash[:info] = "You have successfully signed out."
    redirect_to root_path
  end
end
