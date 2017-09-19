defmodule KafkaMessageBus do
  def produce(data, key, action, resource, opts \\ []), do:
    KafkaMessageBus.Producer.produce(data, key, action, resource, opts)
end
