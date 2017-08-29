use Mix.Config

instance_index = fn ->
  "HOSTNAME"
  |> System.get_env
  |> case do
    nil -> 1
    value ->
      try do
         value |> String.split("-") |> List.last |> String.to_integer
      rescue
        _ -> 1
      end
  end
end

config :kafka_message_bus,
  consumers_per_topic: 5,
  instance_index: instance_index.(),
  consumers: [
    {"example", KafkaMessageBus.MessageProcessor.Example}
  ]

config :kafka_ex,
  brokers: [
    {"localhost", 9092},
  ],
  consumer_group: "kafka_message_bus",
  disable_default_worker: false,
  sync_timeout: 3000,
  max_restarts: 10,
  max_seconds: 60,
  use_ssl: false,
  kafka_version: "0.9.0"
