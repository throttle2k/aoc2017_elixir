defmodule Day12.DigitalPlumber do
  def part1() do
    with {:ok, input} <- File.read("priv/day12/input.txt") do
      input
      |> parse()
      |> groups_containing(0)
    end
  end

  def part2() do
    with {:ok, input} <- File.read("priv/day12/input.txt") do
      input
      |> parse()
      |> count_groups()
    end
  end

  def groups_containing(pipes, program) do
    find_connected_group(pipes, program)
    |> Enum.count()
  end

  defp find_connected_group(pipes, start_program) do
    do_find_connected([start_program], MapSet.new([start_program]), pipes)
  end

  defp do_find_connected([], visited, _pipes), do: MapSet.to_list(visited)

  defp do_find_connected([current | queue], visited, pipes) do
    connections = Map.get(pipes, current)

    new_connections =
      connections
      |> Enum.filter(&(not MapSet.member?(visited, &1)))

    new_queue = queue ++ new_connections
    new_visited = Enum.reduce(new_connections, visited, &MapSet.put(&2, &1))
    do_find_connected(new_queue, new_visited, pipes)
  end

  def count_groups(pipes) do
    do_count_groups(pipes, MapSet.new(Map.keys(pipes)), [])
    |> Enum.count()
  end

  defp do_count_groups(_pipes, remaining, groups) when remaining == %MapSet{}, do: groups

  defp do_count_groups(pipes, remaining, groups) do
    start_program = remaining |> Enum.at(0)
    group = find_connected_group(pipes, start_program)

    new_remaining = Enum.reduce(group, remaining, &MapSet.delete(&2, &1))

    do_count_groups(pipes, new_remaining, [group | groups])
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, acc ->
      {program, connections} = parse_line(line)
      Map.put(acc, program, connections)
    end)
  end

  defp parse_line(line) do
    line
    |> String.split(" <-> ")
    |> then(fn [program_string, connections_string] ->
      {program_string |> String.to_integer(),
       connections_string |> String.trim() |> String.split(", ") |> Enum.map(&String.to_integer/1)}
    end)
  end
end
