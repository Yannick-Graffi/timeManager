# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :timeManager,
  ecto_repos: [TimeManager.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :timeManager, TimeManagerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: TimeManagerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TimeManager.PubSub,
  live_view: [signing_salt: "kWhpoIAj"],
  # http: [port: 4000],  # HTTP disabled
  https: [            # HTTPS enabled
    port: 4001,
    cipher_suite: :strong,
    keyfile: "priv/cert/selfsigned_key.pem",  # Replace with your certificate key file
    certfile: "priv/cert/selfsigned.pem"      # Replace with your certificate file
  ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
#config :timeManager, TimeManager.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :timeManager, TimeManager.Auth.Guardian,
       issuer: "timeManager",
       secret_key: "8tX3py93FH2Y1Q2K+Rs6tZHo/7eQ7kHTFJX5F/kH3tARp9I5/uZfaZzgzzuuswpa",
       verify_module: Guardian.DB

config :guardian, Guardian.DB,
       repo: TimeManager.Repo, # Add your repository module
       schema_name: "guardian_tokens", # default
       sweep_interval: 60 # default: 60 minutes

#config :cors_plug,
#       origin: ["http://localhost:5173"],
#       max_age: 86400,
#       methods: ["GET", "POST"]

# Swagger
config :timeManager, :phoenix_swagger,
       swagger_ui_path: "/api/swagger",
       generate_swagger_file: false,
       hide_generated_tag: true,
       hide_default_endpoint: true,
       hide_auth_header: true,
       swagger_files: %{
         "priv/static/swaggerDefault.json" => [
           router: TimeManagerWeb.Router,
           endpoint: TimeManagerWeb.Endpoint
         ]
       }

# Jason (a JSON library)
config :phoenix_swagger, json_library: Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
