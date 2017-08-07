class UserController < ApplicationController
  before_action do
    only [:edit, :update] do
      unless current_user? && current_user.id == params["id"].to_i
        redirect_to_sign_in
      end
    end

    only [:index, :show, :new, :create, :destroy] { authenticate_owner! }
  end

  def index
    return error if error?
    users = User.all
    render("index.slang")
  end

  def show
    return error if error?
    if user = User.find params["id"]
      render("show.slang")
    else
      flash["warning"] = "User with ID #{params["id"]} Not Found"
      redirect_to "/users"
    end
  end

  def new
    return error if error?
    user = User.new
    render("new.slang")
  end

  def create
    return error if error?
    user = User.new(params.to_h.select(["email", "level"]))
    user.password = params["password"]

    if params["password"] == params["confirm_password"] && user.valid? && user.save
      flash["success"] = "Created User successfully."
      redirect_to "/users"
    else
      flash["danger"] = "Could not create User!"
      render("new.slang")
    end
  end

  def edit
    return error if error?
    if user = User.find params["id"]
      render("edit.slang")
    else
      flash["warning"] = "User with ID #{params["id"]} Not Found"
      redirect_to root_path
    end
  end

  def update
    return error if error?
    if user = User.find(params["id"])
      old_password, user.password = user.password, params["password"]
      if old_password == params["old_password"] && params["password"] == params["confirm_password"] && user.valid? && user.save
        flash["success"] = "Updated User successfully."
        redirect_to root_path
      else
        flash["danger"] = "Could not update User!"
        render("edit.slang")
      end
    else
      flash["warning"] = "User with ID #{params["id"]} Not Found"
      redirect_to root_path
    end
  end

  def destroy
    return error if error?
    if user = User.find params["id"]
      user.destroy
    else
      flash["warning"] = "User with ID #{params["id"]} Not Found"
    end
    redirect_to "/users"
  end
end
