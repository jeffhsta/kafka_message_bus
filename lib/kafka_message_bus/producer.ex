defmodule KafkaMessageBus.Producer do
  require Logger
  alias KafkaEx.Protocol.Produce.{Message, Request}

  def produce(data, key, source \\ "user_service") do
    topic = Application.get_env(:user_service, :kafka_topic)

    value = Poison.encode!(%{
      source: source,
      timestamp: DateTime.utc_now,
      request_id: Logger.metadata |> Keyword.get(:request_id),
      data: data |> Map.delete(:__meta__)
    })

    message = %Message{key: key, value: value}

    produce_request = %Request{
      partition: topic |> take_randon_partition,
      topic: topic,
      messages: [message]
    }

    KafkaEx.produce(produce_request)
  end

  defp take_randon_partition(topic) do
    {_, partitions} = KafkaMessageBus.Manage.identify_partitions(topic)
    0..(partitions - 1) |> Enum.take_random(1) |> List.first
  end
end
