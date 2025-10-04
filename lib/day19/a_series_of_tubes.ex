defmodule Day19.ASeriesOfTubes do
  def part1() do
    with {:ok, input} <- File.read("priv/day19/input.txt") do
      part1_with_input(input)
    end
  end

  def part1_with_input(input) do
    input
    |> parse()
    |> walk()
    |> elem(0)
    |> Enum.reverse()
    |> Enum.join()
  end

  def part2() do
    with {:ok, input} <- File.read("priv/day19/input.txt") do
      part2_with_input(input)
    end
  end

  def part2_with_input(input) do
    input
    |> parse()
    |> walk()
    |> elem(1)
  end

  defp walk(map) do
    start =
      map
      |> Enum.find(fn {_, v} -> v == :start end)
      |> elem(0)

    step(:down, start, map, [], 0)
  end

  defp step(:down, {row, col}, map, acc, count) do
    case Map.get(map, {row, col}) do
      nil ->
        {acc, count}

      :start ->
        step(:down, {row + 1, col}, map, acc, count + 1)

      :v_tube ->
        step(:down, {row + 1, col}, map, acc, count + 1)

      :h_tube ->
        step(:down, {row + 1, col}, map, acc, count + 1)

      :cross_tube ->
        {new_direction, {new_row, new_col}} = turn_left_or_right({row, col}, map)
        step(new_direction, {new_row, new_col}, map, acc, count + 1)

      c ->
        step(:down, {row + 1, col}, map, [c | acc], count + 1)
    end
  end

  defp step(:up, {row, col}, map, acc, count) do
    case Map.get(map, {row, col}) do
      nil ->
        {acc, count}

      :v_tube ->
        step(:up, {row - 1, col}, map, acc, count + 1)

      :h_tube ->
        step(:up, {row - 1, col}, map, acc, count + 1)

      :cross_tube ->
        {new_direction, {new_row, new_col}} = turn_left_or_right({row, col}, map)
        step(new_direction, {new_row, new_col}, map, acc, count + 1)

      c ->
        step(:up, {row - 1, col}, map, [c | acc], count + 1)
    end
  end

  defp step(:left, {row, col}, map, acc, count) do
    case Map.get(map, {row, col}) do
      nil ->
        {acc, count}

      :v_tube ->
        step(:left, {row, col - 1}, map, acc, count + 1)

      :h_tube ->
        step(:left, {row, col - 1}, map, acc, count + 1)

      :cross_tube ->
        {new_direction, {new_row, new_col}} = turn_up_or_down({row, col}, map)
        step(new_direction, {new_row, new_col}, map, acc, count + 1)

      c ->
        step(:left, {row, col - 1}, map, [c | acc], count + 1)
    end
  end

  defp step(:right, {row, col}, map, acc, count) do
    case Map.get(map, {row, col}) do
      nil ->
        {acc, count}

      :v_tube ->
        step(:right, {row, col + 1}, map, acc, count + 1)

      :h_tube ->
        step(:right, {row, col + 1}, map, acc, count + 1)

      :cross_tube ->
        {new_direction, {new_row, new_col}} = turn_up_or_down({row, col}, map)
        step(new_direction, {new_row, new_col}, map, acc, count + 1)

      c ->
        step(:right, {row, col + 1}, map, [c | acc], count + 1)
    end
  end

  defp turn_left_or_right({row, col}, map) do
    case Map.get(map, {row, col + 1}) do
      :h_tube -> {:right, {row, col + 1}}
      c when is_binary(c) -> {:right, {row, col + 1}}
      _ -> {:left, {row, col - 1}}
    end
  end

  defp turn_up_or_down({row, col}, map) do
    case Map.get(map, {row + 1, col}) do
      :v_tube -> {:down, {row + 1, col}}
      c when is_binary(c) -> {:down, {row + 1, col}}
      _ -> {:up, {row - 1, col}}
    end
  end

  defp parse(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, &parse_line/2)
  end

  defp parse_line({line, row}, acc) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {char, col} -> {char, col, row} end)
    |> Enum.reduce(acc, &parse_cell/2)
  end

  defp parse_cell({" ", _col, _row}, acc), do: acc
  defp parse_cell({"|", col, 0}, acc), do: Map.put(acc, {0, col}, :start)
  defp parse_cell({"|", col, row}, acc), do: Map.put(acc, {row, col}, :v_tube)
  defp parse_cell({"-", col, row}, acc), do: Map.put(acc, {row, col}, :h_tube)
  defp parse_cell({"+", col, row}, acc), do: Map.put(acc, {row, col}, :cross_tube)
  defp parse_cell({c, col, row}, acc), do: Map.put(acc, {row, col}, c)
end
