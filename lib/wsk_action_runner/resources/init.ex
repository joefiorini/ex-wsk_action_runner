defmodule WskActionRunner.Resources.Init do
  def init(_), do: {{:trace, "/tmp"}, {nil, []}}

  def ping(req_data, state), do: {:pong, req_data, state}

  def allowed_methods(req_data, state) do
    {[:POST], req_data, state}
  end

  def process_post(req_data, state) do
    IO.puts "process_post"
    IO.inspect :wrq.req_body(req_data)

    {true, req_data, state}
  end
end
