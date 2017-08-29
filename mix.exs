defmodule KafkaMessageBus.Mixfile do
  use Mix.Project

  def project, do: [
    app: :kafka_message_bus,
    version: "0.1.0",
    elixir: "~> 1.4",
    build_embedded: Mix.env == :prod,
    start_permanent: Mix.env == :prod,
    deps: deps(),
    source_url: "https://github.com/jeffhsta/ExKafkaLogger"
  ]

  def application do
    [applications: [:logger, :kafka_ex],
     mod: {KafkaMessageBus.Application, []}]
  end

  defp deps, do: [
    {:kafka_ex, "~> 0.7"},
    {:poison, "~> 2.0"},
    {:ex_doc, ">= 0.0.0", only: :dev}
  ]
end
