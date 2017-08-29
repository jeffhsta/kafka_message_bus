defmodule KafkaMessageBus.Manage do
  alias KafkaEx.Protocol.Produce.{Message, Request}
  require Logger

  def metadata(topic), do: KafkaEx.metadata(topic: topic)

  def identify_partitions(topic) do
    [topic: topic]
    |> KafkaEx.metadata
    |> Map.get(:topic_metadatas)
    |> Enum.map(fn x -> {x.topic, Enum.count(x.partition_metadatas)} end)
    |> List.first
    |> fn {_topic, num_partitions} -> num_partitions end.()
  end

  def setup_consumer({topic, message_processor}) do
    available_partitions = topic |> identify_partitions

    consume_partition = Application.get_env(:kafka_message_bus, :consumers_per_topic)
    instance_index = Application.get_env(:kafka_message_bus, :instance_index)
    start_partition = (instance_index - 1) * consume_partition
    end_partition = (instance_index * consume_partition) - 1

    end_partition = case end_partition < available_partitions do
        true -> end_partition
        false -> available_partitions - 1
      end

    case start_partition > end_partition do
      true -> {:error, "There is no free partition to connect"}
      false -> {:ok, start_partition..end_partition}
    end
  end
end
