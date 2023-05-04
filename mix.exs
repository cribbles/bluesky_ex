defmodule BlueskyEx.MixProject do
  use Mix.Project

  @scm_url "https://github.com/cribbles/bluesky_ex"

  def project do
    [
      app: :bluesky_ex,
      version: "0.1.4",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "bluesky_ex",
      docs: [
        extras: ["README.md"]
      ]
    ]
  end

  def description do
    """
    An Elixir client for the Bluesky / AT protocol.
    """
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Chris Sloop"],
      licenses: ["MIT"],
      links: %{"GitHub" => @scm_url}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 2.1"},
      {:jason, "~> 1.3"},
      {:credo, "~> 1.7.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.29.4", only: :dev, runtime: false},
      {:dialyxir, "~> 1.3.0", only: [:dev, :test], runtime: false}
    ]
  end
end
