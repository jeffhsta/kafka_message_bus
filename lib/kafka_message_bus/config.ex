defmodule KafkaMessageBus.Config do

  @lib_name :kafka_message_bus

  def instance_index, do:
    Application.get_env(@lib_name, :instance_index, default_instance_index())

  def consumers_per_topic, do:
    Application.get_env(@lib_name, :consumers_per_topic, 5)

  def consumers, do:
    Application.get_env(@lib_name, :consumers, [])

  def default_topic, do:
    Application.get_env(@lib_name, :default_topic)

  def source, do:
    Application.get_env(@lib_name, :source)

  defp default_instance_index do
    ~r/^.*-(\d+)$/
    |> Regex.run("#{System.get_env("HOSTNAME")}")
    |> List.last
    |> String.to_integer
  end
end
