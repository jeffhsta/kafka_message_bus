use Mix.Config

config :kafka_message_bus,
  default_topic: "example",
  source: "example_service",
  heartbeat_interval: 1_000,
  commit_interval: 1_000,
  partitioner: KafkaMessageBus.Partitioner.Random,
  consumers: [
    {"example", KafkaMessageBus.MessageProcessor.Example}
  ]

config :kaffe,
  consumer: [
    endpoints: [localhost: 9092],
    topics: ["kafka_message_bus"],
    consumer_group: "kafka_message_bus",
    message_handler: KafkaMessageBus.MessageProcessor,
    async_message_ack: false,
    offset_commit_interval_seconds: 10,
    start_with_earliest_message: false,
    rebalance_delay_ms: 100,
    max_bytes: 10_000,
    subscriber_retries: 5,
    subscriber_retry_delay_ms: 5,
    worker_allocation_strategy: :worker_per_topic_partition
    ],
  producer: [
    partition_strategy: :md5,
    endpoints: [kafka: 9092],
    topics: ["kafka_message_bus"]
  ],
  kafka_mod: :brod

config :logger,
  backends: [:console],
  level: :debug
