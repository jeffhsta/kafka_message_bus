defmodule KafkaMessageBus.Producer do
  require Logger
  alias Kaffe.Producer
  alias KafkaMessageBus.Config

  def produce(data, key, opts \\ []) do
    topic = opts |> Keyword.get(:topic, Config.default_topic)
    source = opts |> Keyword.get(:source, Config.source)

    value = %{
      source: source,
      timestamp: DateTime.utc_now,
      request_id: Logger.metadata |> Keyword.get(:request_id),
      data: data |> Map.delete(:__meta__)
    }
    |> Poison.encode!

    Producer.produce_sync(topic, [{key, value}])
  end
end
