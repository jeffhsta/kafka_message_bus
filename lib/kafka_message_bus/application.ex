defmodule KafkaMessageBus.Application do
  use Application
  @retry_strategy Application.get_env(:kafka_message_bus, :retry_strategy)


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
