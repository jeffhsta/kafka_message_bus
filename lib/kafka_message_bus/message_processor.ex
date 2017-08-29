defmodule KafkaMessageBus.MessageProcessor.Behaviour do
  @type data :: Map.t
  @type key :: String.t
  @type metadata :: Map.t

  @callback process(data, key, metadata) :: {:ok}
  @callback process(data, key, metadata) :: {:error, String.t}
end
