defmodule KafkaMessageBus.MessageProcessor do
  require Logger
  @topics_and_processors Application.get_env(:kafka_message_bus, :consumers)

  def handle_messages(messages) do
    for message = %{key: key, value: value, topic: topic, partition: partition} <- messages do
      Logger.debug fn -> "Got message: #{topic}/#{partition} - #{key}, #{value}" end
      process_message(message)
    end
    :ok
  end

  def process_message(message) do
    @topics_and_processors
    |> Enum.map(fn config -> execute_message(message, config) end)
  end

  def execute_message(message = %{topic: topic}, {topic, message_processor}) do
    message.value
    |> Poison.decode()
    |> case do
      {:ok, value} -> value
      {:error, _} -> message.value
    end
    |> message_processor.process(message.key)
    :ok
  end

  def execute_message(_, _) do
    :ok
  end
end
