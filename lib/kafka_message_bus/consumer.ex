defmodule KafkaMessageBus.Consumer do
  use KafkaEx.GenConsumer
  alias KafkaEx.Protocol.Fetch.Message
  alias KafkaMessageBus.Config
  require Logger

  def init(topic, partition) do
    Logger.debug("Initialize worker for #{topic}/#{partition}")

    {:ok, %{
      topic: topic,
      partition: partition,
      message_processor: Config.get_message_processor(topic)
    }}
  end

  def handle_message_set(message_set, state) do
    for %Message{key: key, value: value} <- message_set do
      Logger.debug "Got message: KEY: #{key}, VALUE: #{value}"

      value
      |> Poison.decode!
      |> state.message_processor.process(key)
    end

    {:async_commit, state}
  end
end
