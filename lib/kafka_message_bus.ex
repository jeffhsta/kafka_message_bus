defmodule KafkaMessageBus do
  def produce(data, key, action, opts \\ []), do:
    KafkaMessageBus.Producer.produce(data, key, action, opts)
end
