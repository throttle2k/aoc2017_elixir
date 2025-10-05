defmodule Day25.TheHaltingProblem do
  defmodule State do
    defstruct [:tape, :current_state, :position]

    def new() do
      %__MODULE__{tape: %{0 => 0}, current_state: :a, position: 0}
    end
  end

  @transitions %{
    {:a, 0} => {1, :right, :b},
    {:a, 1} => {0, :left, :b},
    {:b, 0} => {1, :left, :c},
    {:b, 1} => {0, :right, :e},
    {:c, 0} => {1, :right, :e},
    {:c, 1} => {0, :left, :d},
    {:d, 0} => {1, :left, :a},
    {:d, 1} => {1, :left, :a},
    {:e, 0} => {0, :right, :a},
    {:e, 1} => {0, :right, :f},
    {:f, 0} => {1, :right, :e},
    {:f, 1} => {1, :right, :a}
  }

  def part1(transitions \\ @transitions, steps \\ 12_861_455) do
    step(State.new(), transitions, steps)
    |> checksum()
  end

  defp step(state, _transitions, 0), do: state

  defp step(state, transitions, steps) do
    {new_val, direction, new_state} =
      Map.get(transitions, {state.current_state, current_value(state)})

    state
    |> update_value(new_val)
    |> move(direction)
    |> update_state(new_state)
    |> step(transitions, steps - 1)
  end

  defp current_value(state), do: Map.get(state.tape, state.position, 0)

  defp update_value(state, new_val),
    do: %{state | tape: Map.update(state.tape, state.position, new_val, fn _ -> new_val end)}

  defp move(state, :right), do: %{state | position: state.position + 1}
  defp move(state, :left), do: %{state | position: state.position - 1}

  defp update_state(state, new_state), do: %{state | current_state: new_state}

  defp checksum(state), do: Enum.count(state.tape, fn {_k, v} -> v == 1 end)
end
