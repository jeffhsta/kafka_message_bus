defmodule KafkaMessageBus do
  def produce(data, key, opts \\ []), do:
    KafkaMessageBus.Producer.produce(data, key, opts)
end
