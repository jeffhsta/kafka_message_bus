defmodule KafkaMessageBus.Partitioner.Random do

  def assign_partition(_key, partitions) do
    0..(partitions - 1) |> Enum.take_random(1) |> List.first
  end
end
