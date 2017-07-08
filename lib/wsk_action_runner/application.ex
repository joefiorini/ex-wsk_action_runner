defmodule WskActionRunner.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Application.put_env(:webmachine, :log_handlers, [
          webmachine_access_log_handler: ["log"],
          webmachine_error_log_handler: ["log"]
        ])

    # Some configuration that Webmachine needs
    web_config = [ip: {127, 0, 0, 1},
                  port: 8080,
                  log_dir: "log",
                  dispatch: [
                    {['init'], WskActionRunner.Resources.Init, []},
                    {['run'], WskActionRunner.Resources.Run, []}
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
