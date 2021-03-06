defmodule KafkaMessageBus.Config do
  @moduledoc false

  alias Supervisor.Spec

  @lib_name :kafka_message_bus

  def default_topic, do: Application.get_env(@lib_name, :default_topic)

  def source, do: Application.get_env(@lib_name, :source)

  def partitioner, do: Application.get_env(@lib_name, :partitioner)

  def retry_strategy, do: Application.get_env(:kafka_message_bus, :retry_strategy)

  def heartbeat_interval,
    do: Application.get_env(@lib_name, :heartbeat_interval, 1_000)

  def commit_interval,
    do: Application.get_env(@lib_name, :commit_interval, 1_000)

  def topic_names do
    @lib_name
    |> Application.get_env(:consumers, [])
    |> Enum.map(&elem(&1, 0))
  end

  def get_message_processor(topic) do
    @lib_name
    |> Application.get_env(:consumers, [])
    |> Enum.filter(fn {t, _} -> t == topic end)
    |> List.first()
    |> elem(1)
  end

  def consumer_group_opts do
    [
      heartbeat_interval: heartbeat_interval(),
      commit_interval: commit_interval()
    ]
  end

  def queue_supervisor do
    case retry_strategy() do
      :exq ->
        [Spec.supervisor(Exq, [])]

      _ ->
        []
    end
  end
end
