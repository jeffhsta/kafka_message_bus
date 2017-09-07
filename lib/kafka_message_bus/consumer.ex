defmodule KafkaMessageBus.Consumer do
  use GenServer
  require Logger

  @one_minute_delay 1000 * 60

  alias KafkaEx.Protocol.Fetch.Message

  def start_link(topic, partition, message_processor), do:
    GenServer.start_link(__MODULE__, [
        topic: topic,
        partition: partition,
        message_processor: message_processor
      ])

  def init([topic: topic, partition: partition, message_processor: message_processor]) do
    Process.send_after(self(), :listen, @one_minute_delay)
    kafka_worker(topic, partition)

    {:ok, %{
      stream: open_stream(topic, partition),
      topic: topic,
      partition: partition,
      message_processor: message_processor
    }}
  end

  def handle_info(:listen, state) do
    for message <- state.stream do
      try do
        message |> dispatch(state.message_processor)
      rescue
        error -> Logger.error("Error in process message #{state.topic}/#{state.partition}, #{inspect error}")
      end
    end
    {:noreply, state}
  end

  defp dispatch(%Message{key: key, value: value}, message_processor) do
    value
    |> Poison.decode!
    |> fn data ->
      Logger.metadata(request_id: data["request_id"])
      Logger.debug(fn -> "Got message KEY: #{key}, VALUE: #{value}" end)
      data
    end.()
    |> message_processor.process(key)
  end

  defp kafka_worker(topic, partition) do
    worker_name = "kafka_connection_#{topic}_#{partition}" |> String.to_atom
    worker_name
    |> GenServer.whereis
    |> case do
      nil -> {:ok, _} = KafkaEx.create_worker(worker_name)
      _ -> :ok
    end

    worker_name
  end

  defp open_stream(topic, partition) do
    kafka_worker = kafka_worker(topic, partition)
    KafkaEx.stream(topic, partition, worker_name: kafka_worker)
  end
end
