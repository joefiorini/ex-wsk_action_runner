# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

config :webmachine,
  log_handlers: [
    {:webmachine_access_log_handler, ["log"]},
    {WskActionRunner.Application.ErrorHandler, ["log"]}
  ]

config :mix_docker, image: "joefiorini/moneyalarms-elixir"

config :wsk_action_runner,
  couchdb: [
    username:  {:system, "COUCHDB_USERNAME"},
    password:  {:system, "COUCHDB_PASSWORD"},
    host:      {:system, "COUCHDB_HOST"},
    port:      {:system, :integer, "COUCHDB_PORT"},
    url:       {:system, "COUCHDB_URL"},
    database:  {:system, "COUCHDB_DATABASE", "testdb"}
  ]


# You can configure for your application as:
#
#     config :wsk_action_runner, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:wsk_action_runner, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
