defmodule KafkaMessageBus.Consumer do
  require Logger
  @processor_config Application.get_env(:kafka_message_bus, :consumers)
  @retry_strategy Application.get_env(:kafka_message_bus, :retry_strategy)

  def handle_messages(messages) do
    for message <- messages do
      Logger.debug fn ->
        "Got message: #{message.topic}/#{message.partition} -> #{message.key}: #{message.value}"
      end

      message.value
      |> Poison.decode()
      |> process_message(message.topic)
    end
    :ok
  end

  defp process_message({:ok, data}, topic) do
    Logger.metadata(request_id: data["request_id"])
    @processor_config
    |> Enum.each(&execute_message(data, topic, &1))
  end

  defp process_message({:error, error}, topic) do
    Logger.error("Failed to parse message in topic #{topic}. Error: #{inspect error}")
  end

  defp execute_message(data = %{"resource" => resource}, topic, {topic, resource, message_processor}) do
    try do
      message_processor.process(data)
    catch
      _ -> enqueue_message_retry(data, message_processor)
    end
  end

  defp execute_message(data, _, _) do
    Logger.debug fn -> "Ignoring message with data: #{inspect data}" end
    :ok
  end

  def enqueue_message_retry(data, message_processor) when @retry_strategy == :exq do
    KafkaMessageBus.ConsumerEnqueuer.enqueue(data, message_processor)
  end

  def enqueue_message_retry(data, message_processor) do
    Logger.warn("Will not retry message with data: #{data}")
  end
end
