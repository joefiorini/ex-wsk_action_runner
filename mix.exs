defmodule WskActionRunner.Mixfile do
  use Mix.Project

  def project do
    [app: :wsk_action_runner,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [applications: [:logger, :webmachine, :absinthe, :poison, :confex, :couchdb_connector],
     mod: {WskActionRunner.Application, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:webmachine,
      git: "https://github.com/webmachine/webmachine.git",
      branch: "master"},
     {:absinthe, "~> 1.3.2"},
     {:poison, "~> 3.1"},
     {:distillery, "~> 1.4", runtime: false},
     {:mix_docker, "~> 0.5.0"},
     {:hackney, "~> 1.8.6"},
     {:jsx, "~> 2.8"},
     {:confex, "~> 3.2.2"},
     {:couchdb_connector, "~> 0.5.0"}
    ]
  end
end
