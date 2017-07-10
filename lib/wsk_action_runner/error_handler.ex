defmodule WskActionRunner.Application.ErrorHandler do
  require Logger

  def init([_baseDir]) do
    # file_name = Path.join(baseDir, "wm_error.log")
    {:ok, []}
  end

  def handle_event({:log_error, code, _req_data, reason}, state) do
    Logger.error("Error: Webmachine Server is returning #{Integer.to_string(code)}")
    Logger.error(inspect(reason, label: "Reason:"))
    Logger.error("State: #{inspect(state)}")
    # Logger.error("The result from the resource was:")
    # Logger.error(Inspect.inspect(result, {}))
    {:ok, state}
  end

  def handle_event(event, state) do
    IO.inspect(event, pretty: true, label: "LOGGED EVENT")
    {:ok, state}
  end
end
