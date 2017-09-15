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

  def process_message(message) do
    @topics_and_processors
    |> Enum.map(fn config -> execute_message(message, config) end)
  end

  def execute_message(message = %{topic: topic}, {topic, message_processor}) do
    message.value
    |> Poison.decode!
    |> message_processor.process(message.key)
    :ok
  end

  def execute_message(_, _) do
    :ok
  end
end
