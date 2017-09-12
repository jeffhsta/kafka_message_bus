defmodule KafkaMessageBus.Partitioner.Hashed do

  def assign_partition(key, partitions) do
    :erlang.phash2(key, partitions)
  end
end
