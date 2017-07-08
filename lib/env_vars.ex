defmodule WskActionRunner.EnvVars do
  def set_from_payload(env) do
    IO.puts "=== ENV ==="
    IO.inspect env
  end
end
