defmodule Day22.SporificaVirus.Part2 do
  alias Day22.SporificaVirus
  alias Day22.SporificaVirus.State

  def part2() do
    with {:ok, input} <- File.read("priv/day22/input.txt") do
      part2_with_input(input)
    end
  end

  def part2_with_input(input) do
    input
    |> SporificaVirus.parse()
    |> burst(10_000_000)
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
    case State.current_node(state) do
      :clean ->
        State.update_current_node(state, :weakened)

      :weakened ->
        state
        |> State.update_current_node(:infected)
        |> State.increase_infections()

      :infected ->
        State.update_current_node(state, :flagged)

      :flagged ->
        State.update_current_node(state, :clean)
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
  defp turn(:weakened, :north), do: :north
  defp turn(:weakened, :west), do: :west
  defp turn(:weakened, :south), do: :south
  defp turn(:weakened, :east), do: :east
  defp turn(:flagged, :north), do: :south
  defp turn(:flagged, :west), do: :east
  defp turn(:flagged, :south), do: :north
  defp turn(:flagged, :east), do: :west

  defp move(state), do: State.update_position(state, move(state.position, state.direction))
  defp move({row, col}, :north), do: {row - 1, col}
  defp move({row, col}, :west), do: {row, col - 1}
  defp move({row, col}, :south), do: {row + 1, col}
  defp move({row, col}, :east), do: {row, col + 1}
end
