defmodule KafkaMessageBus.Mixfile do
  use Mix.Project

  def project,
    do: [
      app: :kafka_message_bus,
      version: "3.0.0",
      elixir: "~> 1.6.5",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "KafkaMessageBus",
      source_url: "https://github.com/heckfer/kafka_message_bus"
    ]

  defp description do
    """
    Wrapper for Kaffe for internal use
    """
  end

  defp package do
    [
      maintainers: [
        "Alan Ficagna",
        "Eduardo Cunha",
        "Fernando Heck",
        "Gabriel Alves",
        "Matthias Nunes"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/heckfer/kafka_message_bus"}
    ]
  end

  def application do
    [applications: [:logger, :kaffe], mod: {KafkaMessageBus.Application, []}]
  end

  defp deps,
    do: [
      {:kaffe, "~> 1.9"},
      {:exq, "~> 0.12.1"},
      {:poison, "~> 3.1"},
      {:credo, "~> 0.9.3", only: [:dev, :test], runtime: false}
    ]
end
