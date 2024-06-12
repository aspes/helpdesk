# config :helpdesk, ash_domains: [Helpdesk.Support]

# in config/config.exs
import Config

config :helpdesk, :ash_domains, [Helpdesk.Support]

config :helpdesk,
  ecto_repos: [Helpdesk.Repo]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
