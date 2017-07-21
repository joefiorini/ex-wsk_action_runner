defmodule WskActionRunner.Application do
  use Application

  def read_config(config) do
    %{protocol: "https",
      hostname: config[:host],
      database: config[:database],
      port: config[:port],
      user: config[:username],
      password: config[:password]
    }
  end

  def parse_couchdb_response({:error, error_response}) do
    {:error, Poison.Parser.parse!(error_response)}
  end

  def parse_couchdb_response(response) do
    response
  end

  def create_or_touch_db(config) do
    Couchdb.Connector.Storage.storage_up(config)
    |> parse_couchdb_response()
    |> case do
      {:ok, _} -> {:ok, config}
      {:error, %{"error" => "file_exists"}} -> {:ok, config}
      {:error, error} -> {:error, error}
    end
  end

  def get_db_config() do
    case Confex.fetch_env(:wsk_action_runner, :couchdb) do
      {:ok, config} ->
        read_config(config)
        |> create_or_touch_db()
       _ = e -> e
    end
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    {:ok, db_config} = get_db_config()

    # Some configuration that Webmachine needs
    web_config = [ip: {0, 0, 0, 0},
                  port: 8080,
                  dispatch: [
                    {['init'], WskActionRunner.Resources.Init, [%{db_config: db_config}]},
                    {['run'], WskActionRunner.Resources.Run, [%{db_config: db_config}]}
                  ]]

    # Add the webmachine+mochiweb listener
    children = [
      worker(:webmachine_mochiweb, [web_config],
        function: :start,
        modules: [:mochiweb_socket_server])
    ]

    opts = [strategy: :one_for_one, name: WskActionRunner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
