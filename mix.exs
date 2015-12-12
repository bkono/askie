defmodule Askie.Mixfile do
  use Mix.Project

  def project do
    [app: :askie,
     description: "SDK and useful helpers for building wth the Alexa Skills Kit",
     package: package,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :plug, :cowboy]]
  end

  defp deps do
    [{:plug, "~> 1.0"},
     {:cowboy, "~> 1.0"}]
  end

  def package do
    [contributors: ["Bryan Konowitz"],
     licenses: "MIT",
     links: %{github: "https://github.com/bkono/askie"},
     files: ~w(lib mix.exs README.md)]
  end
end
