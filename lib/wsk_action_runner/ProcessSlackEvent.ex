defmodule ProcessSlackEvent do
  def run({%{"type" => "url_verification", "challenge" => challenge, "token" => token}, req_data, state}) do
    %{"challenge" => challenge}
  end
end
