defmodule KafkaMessageBus.Partitioner.Random do
  require Logger

  defp assign_partition(_key) do
    partitions = KafkaMessageBus.Manage.identify_partitions(topic)
    0..(partitions - 1) |> Enum.take_random(1) |> List.first
  end
end
