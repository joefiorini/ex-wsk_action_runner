defmodule WskActionRunner.Schema do
  use Absinthe.Schema

  object :greeting do
    field :greeting, :string
  end

  object :greeting_log do
    field :greetings, list_of(:string)
  end

  query do
    field :greet, :greeting do
      arg :name, :string
      resolve fn %{name: name}, %{context: %{db_config: db_config}} ->
        IO.inspect(db_config, label: "db_config in resolver")
        Couchdb.Connector.create_generate(db_config, %{"type" => "greeting", "greeting" => "Hello #{name}"})
        {:ok, %{greeting: "Hello #{name}"}}
      end
    end

    field :greeting_log, :greeting_log do
      resolve fn (_, %{context: %{db_config: db_config}}) ->
        case Couchdb.Connector.View.fetch_all(db_config, "all_greetings", "all-greetings") do
          {:ok, response} ->
            Poison.Parser.parse!(response)
            |> Map.get("rows")
            |> Enum.map(fn row -> row["key"] end)
            |> (fn greetings -> {:ok, %{greetings: greetings}} end).()
          {:error, e} -> {:error, e}
        end
      end
    end
  end
end
