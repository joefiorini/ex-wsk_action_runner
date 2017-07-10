defmodule WskActionRunner.Resources.Init do
  def init(_), do: {:ok, {nil, []}}

  def ping(req_data, state), do: {:pong, req_data, state}

  def allowed_methods(req_data, state) do
    IO.puts "allowed_methods"
    {[:POST], req_data, state}
  end

  def content_types_provided(req_data, state) do
    {[{'application/json', :to_json}], req_data, state}
  end

  def to_json(req_data, state) do
    {'{}', req_data, state}
  end

  def set_response({body, req_data, state}) do
    req_data
    |> Utils.set_resp_body(body)
    |> Utils.set_response_code(200)
    |> Utils.return_req_data(state)
  end

  def process_post(req_data, state) do
    IO.puts "process_post"
    IO.inspect :wrq.req_body(req_data)

    {true, req_data, state}
    |> Utils.bind_result(&to_json/2)
    |> Utils.bind_result(&set_response/1)
  end
end
