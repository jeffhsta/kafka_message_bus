defmodule KafkaMessageBus.ConsumerEnqueuer do
  require Logger

  @queue_name "dead_letter_queue"

  def enqueue(msg_content, message_processor), do:
    Exq.enqueue(Exq, @queue_name, __MODULE__, [msg_content, message_processor])

  def perform(msg_content, message_processor) do
    Logger.info("Retrying message with content: #{inspect msg_content}")

    message_processor
    |> String.to_atom
    |> fn processor -> processor.process(msg_content) end.()
  end
end
