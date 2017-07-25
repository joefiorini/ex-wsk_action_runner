defmodule ProcessGithubWebhook do
  def run(%{"action" => "review_requested"} = payload) do
    IO.puts("Someone requested a review!")
    IO.inspect(payload)
    %{}
  end

  def run(%{"action" => "review_request_removed"} = payload) do
    IO.puts("Someone changed their mind.")
    IO.inspect(payload)
    %{}
  end

  def run(%{"zen" => advice }) do
    IO.puts("Received some good advice from GitHub:")
    IO.puts(advice)
    %{}
  end
end
