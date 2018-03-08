Amber::Server.configure do |app|
  pipeline :web do
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
    plug Amber::Pipe::CSRF.new
    plug Amber::Pipe::Reload.new if Amber.env.development?
  end

  pipeline :api do
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
  end

  # All static content will run these transformations
  pipeline :static do
    plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Static.new("./public")
  end

  routes :web do
    resources "/users", UserController
    resources "/oauth/authorized_applications", OAuth::AuthorizedApplicationController, only: [:index, :show, :destroy]
    resources "/oauth/clients", OAuth::ClientController
    get "/oauth/authorize", OAuth::AuthorizationController, :new
    post "/oauth/authorize", OAuth::AuthorizationController, :create
    delete "/oauth/authorize", OAuth::AuthorizationController, :destroy

    get "/", HomeController, :index
    get "/sign_in", SessionController, :new
    post "/sign_in", SessionController, :create
    delete "/sign_out", SessionController, :destroy
  end

  routes :api do
    post "/oauth/token", OAuth::TokenController, :create
    get "/oauth/token/info", OAuth::TokenInfoController, :show
  end

  routes :static do
    # Each route is defined as follow
    # verb resource : String, controller : Symbol, action : Symbol
    get "/*", Amber::Controller::Static, :index
  end
end
