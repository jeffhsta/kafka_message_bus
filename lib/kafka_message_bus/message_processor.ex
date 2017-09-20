defmodule KafkaMessageBus.MessageProcessor.Behaviour do
  @type msg_content :: Map.t
  @type key :: String.t
  @type action :: String.t
  @type resource :: String.t

  @callback process(msg_content, key, action, resource) :: :ok
end

defmodule KafkaMessageBus.MessageProcessor do
  def process(msg_content) do
    IO.puts "Processed message with content: #{inspect msg_content}"
  end
end
