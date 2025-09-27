defmodule Day11.HexEd do
  def part1() do
    with {:ok, input} <- File.read("priv/day11/input.txt") do
      min_steps(input)
    end
  end

  def min_steps(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&parse_step/1)
    |> Enum.reduce({0, 0}, &step/2)
    |> find_path()
  end

  defp find_path(target) do
    do_find_path(target, [{{0, 0}, 0}], %{{0, 0} => 0})
  end

  defp do_find_path(target, [{current_pos, _weight} | _], distances) when current_pos == target,
    do: distances[target]

  defp do_find_path(target, [{current_pos, _weight} | rest], distances) do
    {new_distances, new_candidates} =
      neighbours(current_pos)
      |> Enum.reduce({distances, rest}, fn n, {distances, candidates} ->
        proposed_distance = distances[current_pos] + 1

        if not Map.has_key?(distances, n) or distances[n] > proposed_distance do
          updated_distances = Map.put(distances, n, proposed_distance)

          new_candidates =
            [{n, proposed_distance + heuristic(n, target)} | candidates]
            |> Enum.sort_by(fn {_, weight} -> weight end)

          {updated_distances, new_candidates}
        else
          {distances, candidates}
        end
      end)

    do_find_path(target, new_candidates, new_distances)
  end

  defp neighbours(pos) do
    [:ne, :se, :s, :sw, :nw, :n]
    |> Enum.map(&step(&1, pos))
  end

  defp heuristic({row, col}, {target_row, target_col}) do
    d_row = target_row - row
    d_col = target_col - col

    cond do
      d_row >= 0 and d_col >= 0 -> max(abs(d_row), abs(d_col))
      d_row < 0 and d_col < 0 -> max(abs(d_row), abs(d_col))
      true -> abs(d_row) + abs(d_col)
    end
  end

  def part2() do
    with {:ok, input} <- File.read("priv/day11/input.txt") do
      find_max_dist(input)
    end
  end

  defp find_max_dist(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&parse_step/1)
    |> Enum.reduce({{0, 0}, 0}, fn direction, {pos, max_dist} ->
      new_pos = step(direction, pos)
      new_dist = max(max_dist, heuristic({0, 0}, new_pos))
      {new_pos, new_dist}
    end)
    |> elem(1)
  end

  defp step(:ne, {row, col}), do: {row, col + 1}
  defp step(:se, {row, col}), do: {row + 1, col + 1}
  defp step(:s, {row, col}), do: {row + 1, col}
  defp step(:sw, {row, col}), do: {row, col - 1}
  defp step(:nw, {row, col}), do: {row - 1, col - 1}
  defp step(:n, {row, col}), do: {row - 1, col}

  defp parse_step("ne"), do: :ne
  defp parse_step("se"), do: :se
  defp parse_step("s"), do: :s
  defp parse_step("sw"), do: :sw
  defp parse_step("nw"), do: :nw
  defp parse_step("n"), do: :n
end
