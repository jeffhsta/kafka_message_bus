defmodule KafkaMessageBus.Application do
  use Application

  alias KafkaMessageBus.Config

  def start(_type, _args) do
    import Supervisor.Spec

    [supervisor(Kaffe.Consumer, [])]
    |> Supervisor.start_link(
      strategy: :one_for_one,
      name: KafkaMessageBus.Supervisor
    )
  end
end
