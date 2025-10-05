defmodule Day22.SporificaVirus do
  defmodule State do
    defstruct [:map, :position, :direction, :num_infections]

    def current_node(state), do: Map.get(state.map, state.position, :clean)

    def update_current_node(state, new_status),
      do: %{
        state
        | map: Map.update(state.map, state.position, new_status, fn _ -> new_status end)
      }

    def update_direction(state, new_direction), do: %{state | direction: new_direction}
    def update_position(state, new_position), do: %{state | position: new_position}
    def increase_infections(state), do: %{state | num_infections: state.num_infections + 1}
  end

  def parse(input) do
    rows = String.split(input, "\n", trim: true)
    height = length(rows)
    half_height = div(height, 2)

    width = Enum.at(rows, 0) |> String.trim() |> String.length()
    half_width = div(width, 2)

    map =
      rows
      |> Enum.with_index(-half_height)
      |> Enum.reduce(%{}, fn {row, rownum}, map ->
        row
        |> String.graphemes()
        |> Enum.with_index(-half_width)
        |> Enum.reduce(map, fn
          {".", colnum}, acc -> Map.put(acc, {rownum, colnum}, :clean)
          {"#", colnum}, acc -> Map.put(acc, {rownum, colnum}, :infected)
        end)
      end)

    %State{map: map, position: {0, 0}, direction: :north, num_infections: 0}
  end
end
