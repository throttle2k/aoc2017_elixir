defmodule Day23.CoprocessorConflagration.State do
  defstruct [:registers, :instructions, :ip, :count_mul]

  def get_instruction(%__MODULE__{} = state) do
    Enum.at(state.instructions, state.ip)
  end

  def new(instructions) do
    registers = %{"a" => 0, "b" => 0, "c" => 0, "d" => 0, "e" => 0, "f" => 0, "g" => 0, "h" => 0}
    %__MODULE__{registers: registers, instructions: instructions, ip: 0, count_mul: 0}
  end

  def increase_ip(%__MODULE__{} = state, val \\ 1), do: %{state | ip: state.ip + val}
  def increase_mul(%__MODULE__{} = state), do: %{state | count_mul: state.count_mul + 1}

  def set_register(%__MODULE__{} = state, reg, fun),
    do: %{state | registers: Map.update(state.registers, reg, 0, fun)}
end
