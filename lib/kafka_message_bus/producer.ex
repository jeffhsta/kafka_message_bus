defmodule KafkaMessageBus.Producer do
  require Logger
  alias KafkaEx.Protocol.Produce.{Message, Request}
  alias KafkaMessageBus.Config

  @partitioner Application.get_env(:kafka_message_bus, :partitioner, KafkaMessageBus.Partitioner.Random)

  def produce(data, key, opts \\ []) do
    topic = opts |> Keyword.get(:topic, Config.default_topic)
    partitions = KafkaMessageBus.Manage.identify_partitions(topic)
    partition = opts |> Keyword.get(:partition, @partitioner.assign_partition(key, partitions))
    source = opts |> Keyword.get(:source, Config.source)

    value = %{
      source: source,
      timestamp: DateTime.utc_now,
      request_id: Logger.metadata |> Keyword.get(:request_id),
      data: data |> Map.delete(:__meta__)
    }
    |> Poison.encode!

    %Request{
      partition: partition,
      topic: topic,
      messages: [%Message{key: key, value: value}]
    }
    |> KafkaEx.produce
  end
end
