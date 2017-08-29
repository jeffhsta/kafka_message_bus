defmodule KafkaMessageBus.Application do
  require Logger
  use Application

  def start(_type, _args) do
    children = :kafka_message_bus
      |> Application.get_env(:consumers)
      |> Enum.map(&setup_consumer_partitions/1)
      |> List.flatten

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: KafkaMessageBus.Supervisor
    )
  end

  defp setup_consumer_partitions(topic_config = {topic, message_processor}) do
    topic_config
    |> KafkaMessageBus.Manage.setup_consumer
    |> case do
      {:error, error} ->
        Logger.error(error)
        []

      {:ok, consumable_partitions} ->
        consumable_partitions
        |> Enum.map(&setup_consumer_worker(topic, &1, message_processor))
    end
  end

  defp setup_consumer_worker(topic, partition, message_processor) do
    import Supervisor.Spec, warn: false

    worker_id = "consumer_#{topic}_#{partition}" |> String.to_atom
    Logger.debug fn -> "Setting up Consumer TOPIC: #{topic}, PARTITION: #{partition}, ID: #{worker_id}" end
    worker(KafkaMessageBus.Consumer, [topic, partition, message_processor], id: worker_id)
  end
end
