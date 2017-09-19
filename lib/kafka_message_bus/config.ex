defmodule KafkaMessageBus.Config do
  @lib_name :kafka_message_bus
  @retry_strategy Application.get_env(:kafka_message_bus, :retry_strategy)

  def default_topic, do:
    Application.get_env(@lib_name, :default_topic)

  def source, do:
    Application.get_env(@lib_name, :source)

  def partitioner, do:
    Application.get_env(@lib_name, :partitioner)

  def topic_names do
    @lib_name
    |> Application.get_env(:consumers, [])
    |> Enum.map(&elem(&1, 0))
  end

  def get_message_processor(topic) do
    @lib_name
    |> Application.get_env(:consumers, [])
    |> Enum.filter(fn {t, _} -> t == topic end)
    |> List.first
    |> elem(1)
  end

  def consumer_group_opts do
    [
      heartbeat_interval: Application.get_env(@lib_name, :heartbeat_interval, 1_000),
      commit_interval: Application.get_env(@lib_name, :commit_interval, 1_000)
    ]
  end

  def queue_supervisor() when @retry_strategy == :exq do
    import Supervisor.Spec
    [supervisor(Exq, [])]
  end

  def queue_supervisor() do
    []
  end
end
