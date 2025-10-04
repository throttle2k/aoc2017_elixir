defmodule Day18.Duet.State do
  defstruct [
    :id,
    :instructions,
    :ip,
    :registers,
    :last_sound,
    :queue,
    :parent_pid,
    :other_pid,
    :sent_count,
    :waiting,
    :messages_in_transit
  ]

  def get_value(source, _registers) when is_integer(source), do: source
  def get_value(source, registers) when is_binary(source), do: Map.get(registers, source, 0)
end
