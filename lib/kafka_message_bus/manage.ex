defmodule KafkaMessageBus.Manage do
  def metadata(topic), do: KafkaEx.metadata(topic: topic)

  def identify_partitions(topic) do
    [topic: topic]
    |> KafkaEx.metadata
    |> Map.get(:topic_metadatas)
    |> Enum.map(fn x -> {x.topic, Enum.count(x.partition_metadatas)} end)
    |> List.first
    |> fn {_topic, num_partitions} -> num_partitions end.()
  end
end
