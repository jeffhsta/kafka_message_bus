defmodule KafkaMessageBus.MessageProcessor.Behaviour do
  @type data :: Map.t
  @type key :: String.t
  @type error_message :: String.t

  @callback process(data, key) :: :ok
  @callback process(data, key) :: {:error, error_message}
end
