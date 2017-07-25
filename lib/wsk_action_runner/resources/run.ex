defmodule WskActionRunner.Resources.Run do
  require Logger

  def init([args]), do: {{:trace, "/tmp"}, args}

  def ping(req_data, state), do: {:pong, req_data, state}

  def allowed_methods(req_data, state) do
    {[:POST], req_data, state}
  end

  # TODO: Impelement this later
  #
  # def is_authorized(req_data, state) do
  #   from_json(req_data, state)
  #   |> Utils.bind_result(&body_is_public_action/1)
  #   |> case do
  #        true -> {true, req_data, state}
  #        false -> {{:halt, 401}, req_data, state}
  #      end
  # end

  def process_post(req_data, state) do
    # TODO: Parse this with mochiweb.json, then
    # get args under the "env" key and set them
    # on the environment, get the args under the
    # "data" key and pass it off to absinthe for
    # parsing/dispatching
    # from_json(req_data, state)
    # |> case do
    #     {%{"env" => env, "value" => _value}, _r, _s} ->
    #       WskActionRunner.EnvVars.set_from_payload(env)
    #         {true, req_data, state}
    #     {%{"value" => _value}, _r, _s} ->
    #         {true, req_data, state}
    #   end

    {true, req_data, state}
    |> Utils.bind_result(&to_json/2)
    |> Utils.bind_result(&set_response/1)
  end

  def set_response({body, req_data, state}) do
    req_data
    |> Utils.set_resp_body(body)
    |> Utils.set_response_code(200)
    |> Utils.return_req_data(state)
    |> IO.inspect()
  end

  def content_types_provided(req_data, state) do
    {[{'application/json', :to_json}], req_data, state}
  end

  def to_json(req_data, state) do
    {true, req_data, state}
    |> Utils.bind_result(&from_json/2)
    |> Utils.bind_result(&process_req_body/1)
    |> Utils.return_body(req_data, state)
  end

  def process_req_body({body, req_data, state}) do
    case :wrq.get_req_header("X-GitHub-Event", req_data) do
      :undefined -> ProcessSlackEvent.run(body)
      _ -> ProcessGithubWebhook.run(body)
    end
    |> Poison.encode!
  end

  def extract_graphql_response({:ok, %{data: data}}) do
    data
  end

  def process_graphql_request({body, req_data, %{db_config: db_config} = state}) do
    IO.inspect(db_config, label: "db_config")
    try do
      %{"value" => %{"query" => query}} = body
      query
      |> Absinthe.run(WskActionRunner.Schema, context: %{db_config: db_config})
      |> extract_graphql_response()
      |> IO.inspect
      |> Poison.encode!()
      |> Utils.return_body(req_data, state)
    rescue
      e in Absinthe.ExecutionError ->
        Logger.error(e)
    end
  end

  # def process_body(%{"value" => %{"query" => query} = value}) do
  #   case value do
  #     %{"env" => env} ->
  #       WskActionRunner.EnvVars.set_from_payload(env)
  #   end
  # end

  def process_body(%{"value" => value}) do
    value
  end

  def process_body(body) do
    process_body(%{"value" => body})
  end

  def from_json(req_data, state) do
    body =
    :wrq.req_body(req_data)
    |> Poison.Parser.parse!
    |> process_body()

    IO.puts "body:"
    IO.inspect body
    {body, req_data, state}
  end
end
