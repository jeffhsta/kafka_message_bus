defmodule KafkaMessageBus.Producer do
  require Logger
  alias KafkaEx.Protocol.Produce.{Message, Request}
  alias KafkaMessageBus.Config

  def produce(data, key, opts \\ []) do
    topic = opts |> Keyword.get(:topic, Config.default_topic)
    partition = opts |> Keyword.get(:partition, take_randon_partition(topic))
    source = opts |> Keyword.get(:source, Config.source)

    value = Poison.encode!(%{
      source: source,
      timestamp: DateTime.utc_now,
      request_id: Logger.metadata |> Keyword.get(:request_id),
      data: data |> Map.delete(:__meta__)
    })

    message = %Message{key: key, value: value}

    produce_request = %Request{
      partition: partition,
      topic: topic,
      messages: [message]
    }

    KafkaEx.produce(produce_request)
  end

  defp take_randon_partition(topic) do
    partitions = KafkaMessageBus.Manage.identify_partitions(topic)
    0..(partitions - 1) |> Enum.take_random(1) |> List.first
  end
end
