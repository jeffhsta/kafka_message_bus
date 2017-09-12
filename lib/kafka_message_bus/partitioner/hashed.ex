defmodule KafkaMessageBus.Partitioner.Hashed do
  require Logger

  defp assign_partition(key) do
    partitions = KafkaMessageBus.Manage.identify_partitions(topic)
    :erlang.phash2(key, partitions)
  end
end
