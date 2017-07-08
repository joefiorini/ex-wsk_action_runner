defmodule WskActionRunner.Resources.Hello do
  def init(_) do
    {:ok, nil}
  end

  def ping(req_data, state) do
    {:pong, req_data, state}
  end

  def to_html(req_data, state) do
    {"<html><body>Hello, World!</body></html>", req_data, state}
  end
end
