defmodule KafkaMessageBus do
  def produce(data, key, resource, action, opts \\ []), do:
    KafkaMessageBus.Producer.produce(data, key, resource, action, opts)
end
