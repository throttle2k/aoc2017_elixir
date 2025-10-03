defmodule Day18.Duet.State do
  defstruct [:id, :instructions, :ip, :registers, :last_sound, :waiting]

  def get_value(source, _registers) when is_integer(source), do: source
  def get_value(source, registers) when is_binary(source), do: Map.get(registers, source, 0)
end
