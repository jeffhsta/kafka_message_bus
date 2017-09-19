defmodule KafkaMessageBus.Consumer do
  require Logger
  @topics_resources_and_processors Application.get_env(:kafka_message_bus, :consumers)

  def handle_messages(messages) do
    Logger.debug fn -> "Got #{Enum.count(messages)} messages" end

    for message <- messages do
      message.value
      |> Poison.decode()
      |> process_message(message)
    end
    :ok
  end

  defp process_message({:ok, value}, message) do
    Logger.metadata(request_id: value["request_id"])
    Logger.debug fn -> "Got message: #{message.topic}/#{message.partition} -> #{message.key}: #{value}" end

    @topics_resources_and_processors
    |> Enum.each(&execute_message(message, value, &1))
  end

  defp process_message({:error, raw}, %{topic: topic}) do
    Logger.error("Failed to parse message #{raw} in topic: #{topic}")
  end

  defp execute_message(%{topic: topic}, data = %{resource: resource}, {topic, resource, processor}) do
    processor.process(data)
  end

  defp execute_message(_, _, _), do: :ok
end
