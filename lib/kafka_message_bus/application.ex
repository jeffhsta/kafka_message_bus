defmodule KafkaMessageBus.Application do
  use Application

  alias KafkaMessageBus.Config

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(KafkaEx.ConsumerGroup, [
        KafkaMessageBus.Consumer,
        Config.source,
        Config.topic_names,
        Config.consumer_group_opts
    ])]
    |> Supervisor.start_link(
      strategy: :one_for_one,
      name: KafkaMessageBus.Supervisor
    )
  end
end
