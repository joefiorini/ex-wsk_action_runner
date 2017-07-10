defmodule WskActionRunner.Resources.Run do
  require Logger

  def init(_), do: {{:trace, "/tmp"}, {nil, []}}

  def ping(req_data, state), do: {:pong, req_data, state}

  def allowed_methods(req_data, state) do
    {[:POST], req_data, state}
  end

  def process_post(req_data, state) do
    # TODO: Parse this with mochiweb.json, then
    # get args under the "env" key and set them
    # on the environment, get the args under the
    # "data" key and pass it off to absinthe for
    # parsing/dispatching
    from_json(req_data, state)
    |> case do
        {%{"env" => env, "value" => _value}, _r, _s} ->
          WskActionRunner.EnvVars.set_from_payload(env)
            {true, req_data, state}
        {%{"value" => _value}, _r, _s} ->
            {true, req_data, state}
        _ ->
           {{:halt, {400, 'Missing value with graphql query'}}, req_data, state}
      end
    |> Utils.bind_result(&to_json/2)
    |> Utils.bind_result(&set_response/1)
  end

  def set_response({body, req_data, state}) do
    req_data
    |> Utils.set_resp_body(body)
    |> Utils.set_response_code(200)
    |> Utils.return_req_data(state)
  end

  def content_types_provided(req_data, state) do
    {[{'application/json', :to_json}], req_data, state}
  end

  def to_json(req_data, state) do
    {true, req_data, state}
    |> Utils.bind_result(&from_json/2)
    |> Utils.bind_result(&process_graphql_request/1)
  end

  def extract_graphql_response({:ok, %{data: data}}) do
    data
  end

  def process_graphql_request({body, req_data, state}) do
    try do
      %{"value" => %{"query" => query}} = body
      query
      |> Absinthe.run(WskActionRunner.Schema)
      |> extract_graphql_response()
      |> IO.inspect
      |> Poison.encode!()
      |> Utils.return_body(req_data, state)
    rescue
      e in Absinthe.ExecutionError ->
        Logger.error(e)
    end
  end

  def from_json(req_data, state) do
    body =
    :wrq.req_body(req_data)
    |> Poison.Parser.parse!

    IO.puts "body:"
    IO.inspect body
    {body, req_data, state}
  end
end
