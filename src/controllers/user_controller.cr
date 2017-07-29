class UserController < ApplicationController 

  before_action do
    only [:edit, :update] do
      unless (user = authenticate_user!) && user.is_a?(User) && user.id == params["id"].to_i
        redirect_to root_path
      end
    end

    only [:index, :show, :new, :create, :destroy] { authenticate_owner! } 
  end

  def index
    users = User.all
    render("index.slang")
  end

  def show
    if user = User.find params["id"]
      render("show.slang")
    else
      flash["warning"] = "User with ID #{params["id"]} Not Found"
      redirect_to "/users"
    end
  end

  def new
    user = User.new
    render("new.slang")
  end

  def create
    user = User.new(params.to_h.select(["email", "owner"]))
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
    if user = User.find params["id"]
      render("edit.slang")
    else
      flash["warning"] = "User with ID #{params["id"]} Not Found"
      redirect_to root_path
    end
  end

  def update
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
    if user = User.find params["id"]
      user.destroy
    else
      flash["warning"] = "User with ID #{params["id"]} Not Found"
    end
    redirect_to "/users"
  end
end
