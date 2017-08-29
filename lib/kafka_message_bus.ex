defmodule KafkaMessageBus do
  @moduledoc """
  Documentation for KafkaMessageBus.
  """

  @doc """
  Hello world.

  ## Examples

      iex> KafkaMessageBus.hello
      :world

  """
  def produce(data, key, opts \\ []), do:
    KafkaMessageBus.Producer.produce(data, key, opts)
end
