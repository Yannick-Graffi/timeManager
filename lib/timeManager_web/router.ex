defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    #plug CORSPlug
  end

  pipeline :auth do
    plug TimeManager.Guardian.Pipeline
  end


  scope "/api", TimeManagerWeb do
    pipe_through :api

    post "/login", AuthController, :login
    post "/register", AuthController, :create
  end

  scope "/api", TimeManagerWeb do
    pipe_through [:api, :auth]

    post "/logout", AuthController, :logout
    get "/users/me", UserController, :me
    resources "/users", UserController, except: [:new, :edit]
    resources "/workingTimes", WorkingTimeController, only: [:update, :delete]
    resources "/teams", TeamController, except: [:new, :edit]
    get "/workingTimes/today", WorkingTimeController, :today
    get "/workingTimes/:userID/:id", WorkingTimeController, :show
    get "/workingTimes/:userID", WorkingTimeController, :index
    post "/workingTimes/:userID", WorkingTimeController, :create
    get "/clocks/:userID", ClockController, :show
    post "/clocks", ClockController, :create
  end

  scope "/api/doc" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :timeManager, swagger_file: "swagger.json"
  end
  
  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:timeManager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      #forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
