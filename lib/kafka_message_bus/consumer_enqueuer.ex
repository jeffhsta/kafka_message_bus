defmodule KafkaMessageBus.ConsumerEnqueuer do
  require Logger

  def enqueue(data, message_processor) do
    Exq.enqueue(Exq, "dead_letter_queue", KafkaMessageBus.ConsumerEnqueuer, [data, message_processor])
  end

  def perform(data, message_processor) do
    Logger.warn(fn ->
      "Retrying message with key: #{data.key} and value: #{data.value}"
    end)
    message_processor.process(data)
  end
end
