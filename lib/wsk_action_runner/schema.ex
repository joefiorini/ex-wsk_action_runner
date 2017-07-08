defmodule WskActionRunner.Schema do
  use Absinthe.Schema

  object :greeting do
    field :greeting, :string
  end

  query do
    field :greet, :greeting do
      arg :name, :string
      resolve fn %{name: name}, _ ->
        {:ok, %{greeting: "Hello #{name}"}}
      end
    end
  end
end
