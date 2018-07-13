defmodule KafkaMessageBus.Application do
  @moduledoc false

  alias Kaffe.GroupMemberSupervisor
  alias KafkaMessageBus.Config

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    ([supervisor(GroupMemberSupervisor, [])] ++ Config.queue_supervisor())
    |> Supervisor.start_link(
      strategy: :one_for_one,
      name: KafkaMessageBus.Supervisor
    )
  end
end
