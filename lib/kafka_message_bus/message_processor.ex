defmodule KafkaMessageBus.MessageProcessor.Behaviour do
  @type data :: Map.t
  @type key :: String.t
  @type action :: String.t
  @type resource :: String.t

  @callback process(data, key, action, resource) :: :ok
end

defmodule KafkaMessageBus.MessageProcessor do
  def process(data) do
    IO.puts "Attempt with key: #{data.key} and value: #{data.value}"
    throw "test"
  end
end
