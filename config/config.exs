use Mix.Config

config :kafka_message_bus,
  default_topic: "example",
  source: "example_service",
  heartbeat_interval: 1_000,
  commit_interval: 1_000,
  partitioner: KafkaMessageBus.Partitioner.Random,
  consumers: [
    {"user", "login", KafkaMessageBus.MessageProcessor}
  ]

config :kaffe,
  consumer: [
    endpoints: [localhost: 9092],
    topics: ["user"],
    consumer_group: "kafka_message_bus",
    message_handler: KafkaMessageBus.Consumer,
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

  config :exq,
    name: Exq,
    host: "127.0.0.1",
    port: 6379,
    namespace: "exq",
    concurrency: :infinite,
    start_on_application: false,
    queues: ["dead_letter_queue"],
    poll_timeout: 50,
    scheduler_poll_timeout: 200,
    scheduler_enable: true,
    max_retries: 100,
    shutdown_timeout: 5000
