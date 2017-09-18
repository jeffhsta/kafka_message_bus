defmodule KafkaMessageBus.Consumer do
  require Logger
  @topics_and_processors Application.get_env(:kafka_message_bus, :consumers)

  def handle_messages(messages) do
    Logger.debug fn -> "Got #{Enum.count(messages)} messages" end

    for message <- messages do
      process_message(message)
    end
    :ok
  end

  defp process_message(message) do
    @topics_and_processors
    |> Enum.each(&execute_message(message, &1))
  end

  defp execute_message(message = %{topic: topic}, {topic, message_processor}) do
    data =
      message.value
      |> Poison.decode()
      |> handle_decode_value(message.value)

    Logger.debug(fn ->
      "Got message: #{message.topic}/#{message.partition} -> #{message.key}: #{data}"
    end)
    message_processor.process(data)
  end

  defp execute_message(_, _), do: :ok

  defp handle_decode_value({:error, _}, raw_value), do: raw_value
  defp handle_decode_value({:ok, decoded_value}, _) do
    Logger.metadata(request_id: decoded_value["request_id"])
    decoded_value
  end
end
