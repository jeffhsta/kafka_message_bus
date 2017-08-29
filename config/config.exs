use Mix.Config

config :kafka_message_bus,
  default_topic: "example",
  source: "example_service",
  consumers_per_topic: 5,
  instance_index: 1,
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
