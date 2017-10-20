defmodule KafkaMessageBus.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    [supervisor(Kaffe.GroupMemberSupervisor, [])]
    ++ KafkaMessageBus.Config.queue_supervisor()
    |> Supervisor.start_link(
      strategy: :one_for_one,
      name: KafkaMessageBus.Supervisor
    )
  end
end
