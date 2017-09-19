defmodule KafkaMessageBus.ConsumerEnqueuer do
  require Logger

  def enqueue(value, key, message_processor) do
    Exq.enqueue(Exq, "dead_letter_queue", KafkaMessageBus.ConsumerEnqueuer, [value, key, message_processor])
  end

  def perform(value, key, message_processor) do
    Logger.warn(fn ->
      "Retrying message with key: #{key} and value: #{value}"
    end)
    message_processor.process(value, key)
  end
end
