defmodule KafkaMessageBus.MessageProcessor do
  require Logger
  alias KafkaMessageBus.Config

  def handle_messages(messages) do
    for %{key: key, value: value, topic: topic, partition: partition} <- messages do
      message_processor = Config.get_message_processor(topic)
      Logger.debug fn -> "Got message: #{topic}/#{partition} - #{key}, #{value}" end

      value
      |> Poison.decode
      |> case do
        {:ok, decoded_value} -> decoded_value
        _ -> value
      end
      |> state.message_processor.process(key)
    end
    :ok
  end
end
