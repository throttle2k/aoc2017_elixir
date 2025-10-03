defmodule Day18.Duet.Part1 do
  alias Day18.Duet
  alias Day18.Duet.{Instruction, State}

  def run() do
    with {:ok, input} <- File.read("priv/day18/input.txt") do
      run_with_input(input)
    end
  end

  def run_with_input(input) do
    input
    |> Duet.parse()
    |> execute_program()
  end

  defp execute_program(%State{} = state) do
    do_execute(state)
  end

  defp do_execute(state) do
    case execute(Instruction.get_instruction(state), state) do
      {:cont, new_state} -> do_execute(new_state)
      {:halt, new_state} -> new_state.last_sound
    end
  end

  defp set_register(state, register, val) do
    %{state | registers: Map.put(state.registers, register, val)}
  end

  defp update_register(state, register, fun) do
    %{state | registers: Map.update(state.registers, register, 0, fun)}
  end

  defp update_sound(state, val) do
    %{state | last_sound: val}
  end

  defp advance_ip(state, offset \\ 1), do: %{state | ip: state.ip + offset}

  defp cont(state), do: {:cont, state}
  defp halt(state), do: {:halt, state}

  defp execute({:set, register, value}, %State{} = state) do
    val = State.get_value(value, state.registers)

    state
    |> set_register(register, val)
    |> advance_ip()
    |> cont()
  end

  defp execute({:add, register, value}, %State{} = state) do
    val = State.get_value(value, state.registers)

    state
    |> update_register(register, fn prev -> prev + val end)
    |> advance_ip()
    |> cont()
  end

  defp execute({:mul, register, value}, %State{} = state) do
    val = State.get_value(value, state.registers)

    state
    |> update_register(register, fn prev -> prev * val end)
    |> advance_ip()
    |> cont()
  end

  defp execute({:mod, register, value}, %State{} = state) do
    val = State.get_value(value, state.registers)

    state
    |> update_register(register, fn prev -> rem(prev, val) end)
    |> advance_ip()
    |> cont()
  end

  defp execute({:jgz, v, value}, %State{} = state) do
    check = State.get_value(v, state.registers)
    val = State.get_value(value, state.registers)

    cond do
      check > 0 ->
        state
        |> advance_ip(val)
        |> cont()

      true ->
        state
        |> advance_ip()
        |> cont()
    end
  end

  defp execute({:snd, register}, %State{} = state) do
    val = State.get_value(register, state.registers)

    state
    |> update_sound(val)
    |> advance_ip()
    |> cont()
  end

  defp execute({:rcv, register}, %State{} = state) do
    val = State.get_value(register, state.registers)

    case val do
      0 ->
        state
        |> advance_ip()
        |> cont()

      _ ->
        state
        |> halt()
    end
  end
end
