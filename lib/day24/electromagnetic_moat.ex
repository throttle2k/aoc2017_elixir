defmodule Day24.ElectromagneticMoat do
  def part1() do
    with {:ok, input} <- File.read("priv/day24/input.txt") do
      part1_with_input(input)
    end
  end

  def part1_with_input(input) do
    input
    |> parse()
    |> make_bridges()
    |> Enum.map(fn tubes ->
      tubes
      |> Enum.map(fn {left, right} -> left + right end)
      |> Enum.sum()
    end)
    |> Enum.max()
  end

  def part2() do
    with {:ok, input} <- File.read("priv/day24/input.txt") do
      part2_with_input(input)
    end
  end

  def part2_with_input(input) do
    bridges =
      input
      |> parse()
      |> make_bridges()

    max_length =
      Enum.reduce(bridges, 0, fn tubes, len ->
        if length(tubes) > len, do: length(tubes), else: len
      end)

    bridges
    |> Enum.filter(fn tubes -> length(tubes) == max_length end)
    |> Enum.map(fn tubes ->
      tubes
      |> Enum.map(fn {left, right} -> left + right end)
      |> Enum.sum()
    end)
    |> Enum.max()
  end

  defp make_bridges(input) do
    do_make_bridges(input, 0, [], [])
  end

  defp do_make_bridges([], _dangling_pins, _current_bridge, bridges), do: bridges

  defp do_make_bridges(remaining, dangling_pins, current_bridge, bridges) do
    matches = find_matches(dangling_pins, remaining)

    if Enum.empty?(matches) do
      [current_bridge | bridges]
    else
      Enum.flat_map(matches, fn {left, right} = match ->
        new_remaining = List.delete(remaining, match)
        new_dangling_pins = if left == dangling_pins, do: right, else: left
        do_make_bridges(new_remaining, new_dangling_pins, [match | current_bridge], bridges)
      end)
    end
  end

  defp find_matches(for, list) do
    list
    |> Enum.filter(fn {left, right} -> left == for or right == for end)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split("/", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
