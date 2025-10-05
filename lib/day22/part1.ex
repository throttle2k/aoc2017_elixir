defmodule Day22.SporificaVirus.Part1 do
  alias Day22.SporificaVirus
  alias Day22.SporificaVirus.State

  def part1() do
    with {:ok, input} <- File.read("priv/day22/input.txt") do
      part1_with_input(input)
    end
  end

  def part1_with_input(input) do
    input
    |> SporificaVirus.parse()
    |> burst(10000)
    |> Map.get(:num_infections)
  end

  defp burst(state, 0), do: state

  defp burst(state, n) do
    state
    |> turn()
    |> change_node()
    |> move()
    |> burst(n - 1)
  end

  defp change_node(state) do
    if(State.current_node(state) == :infected) do
      state
      |> State.update_current_node(:clean)
    else
      state
      |> State.update_current_node(:infected)
      |> State.increase_infections()
    end
  end

  defp turn(state),
    do: State.update_direction(state, turn(State.current_node(state), state.direction))

  defp turn(:infected, :north), do: :east
  defp turn(:infected, :east), do: :south
  defp turn(:infected, :south), do: :west
  defp turn(:infected, :west), do: :north
  defp turn(:clean, :north), do: :west
  defp turn(:clean, :west), do: :south
  defp turn(:clean, :south), do: :east
  defp turn(:clean, :east), do: :north

  defp move(state), do: State.update_position(state, move(state.position, state.direction))
  defp move({row, col}, :north), do: {row - 1, col}
  defp move({row, col}, :west), do: {row, col - 1}
  defp move({row, col}, :south), do: {row + 1, col}
  defp move({row, col}, :east), do: {row, col + 1}
end
