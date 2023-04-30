defmodule BlueskyEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :bluesky_ex,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 2.1"},
      {:jason, "~> 1.3"},
      {:credo, "~> 1.7.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.29.4", only: :dev, runtime: false},
      {:dialyxir, "~> 1.3.0", only: [:dev], runtime: false}
    ]
  end
end
