defmodule KafkaMessageBus.Application do
  use Application
  def start(_type, _args) do
    import Supervisor.Spec

    [supervisor(Kaffe.GroupMemberSupervisor, [])]
    |> Supervisor.start_link(
      strategy: :one_for_one,
      name: KafkaMessageBus.Supervisor
    )
  end

  def topic_list do
    Application.get_env(:kafka_message_bus, :consumers)
    |> Enum.map(fn({topic, processor}) -> topic end)
    |> Enum.reduce([], fn(topic, acc) -> acc ++ [topic] end)
  end
end
