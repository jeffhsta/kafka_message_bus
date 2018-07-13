defmodule KafkaMessageBus.Consumer.Behaviour do
  @moduledoc false

  @type msg_content :: Map.t()
  @type msg_error :: String.t()

  @callback process(msg_content) :: :ok | {:error, msg_error}
end
