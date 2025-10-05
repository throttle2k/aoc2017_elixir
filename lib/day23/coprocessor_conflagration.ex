defmodule Day23.CoprocessorConflagration do
  alias Day23.CoprocessorConflagration.{Instruction, State}

  def part1() do
    with {:ok, input} <- File.read("priv/day23/input.txt") do
      parse(input)
      |> run()
      |> Map.get(:count_mul)
    end
  end

  def part2 do
    # value of register b for a = 1
    start_val = 106_700
    # value of register c for a = 1
    end_val = 123_700
    # second to last instruction in the input
    step = 17

    start_val..end_val//step
    |> Enum.count(&composite?/1)
  end

  defp composite?(n) do
    !prime?(n)
  end

  defp prime?(n) when n < 2, do: false
  defp prime?(2), do: true
  defp prime?(n) when rem(n, 2) == 0, do: false

  defp prime?(n) do
    limit = n |> :math.sqrt() |> floor()
    not Enum.any?(3..limit//2, fn d -> rem(n, d) == 0 end)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Instruction.parse_line(&1))
    |> State.new()
  end

  defp run(state) do
    case State.get_instruction(state) do
      nil -> state
      ins -> run(execute(ins, state))
    end
  end

  defp execute({:set, register, val}, %State{} = state) do
    state
    |> State.set_register(register, fn _ -> get_value(val, state) end)
    |> State.increase_ip()
  end

  defp execute({:sub, register, val}, %State{} = state) do
    state
    |> State.set_register(register, fn prev -> prev - get_value(val, state) end)
    |> State.increase_ip()
  end

  defp execute({:mul, register, val}, %State{} = state) do
    state
    |> State.set_register(register, fn prev -> prev * get_value(val, state) end)
    |> State.increase_mul()
    |> State.increase_ip()
  end

  defp execute({:jnz, check, to}, %State{} = state) do
    if get_value(check, state) != 0 do
      State.increase_ip(state, get_value(to, state))
    else
      State.increase_ip(state)
    end
  end

  defp get_value(val, _) when is_integer(val), do: val
  defp get_value(reg, state) when is_binary(reg), do: Map.get(state.registers, reg)
end
