defmodule SenML.MixProject do
  use Mix.Project

  def project do
    [
      app: :senml,
      version: "0.0.1",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.1"},
      {:cortex, "~> 0.1", only: [:dev, :test]}
    ]
  end

  defp package do
    [
      description: "Lightweight implementation of RFC 8428 Sensor Measurement Lists (SenML)",
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sprql/senml.ex"}
    ]
  end
end
