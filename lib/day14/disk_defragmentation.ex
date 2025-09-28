defmodule Day14.DiskDefragmentation do
  def part1(path \\ "priv/day14/input.txt") do
    with {:ok, input} <- File.read(path) do
      input
      |> parse()
      |> Enum.map(fn line ->
        line
        |> Enum.map(&String.to_integer/1)
        |> Enum.sum()
      end)
      |> Enum.sum()
    end
  end

  def part2(path \\ "priv/day14/input.txt") do
    with {:ok, input} <- File.read(path) do
      input
      |> parse()
      |> create_graph()
      |> mark_groups()
    end
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&process_line/1)
  end

  defp process_line(line) do
    line
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(fn n ->
      Integer.parse(n, 16) |> elem(0) |> Integer.to_string(2) |> String.pad_leading(4, "0")
    end)
    |> Enum.join()
    |> String.graphemes()
  end

  def mark_groups(graph) do
    for row <- 0..127, col <- 0..127, reduce: {graph, 1} do
      {g, n} ->
        if Map.get(g, {row, col}) == :no_group do
          {mark_group(g, [{row, col}], n), n + 1}
        else
          {g, n}
        end
    end
    |> elem(1)
    |> Kernel.-(1)
  end

  defp mark_group(graph, [], _n), do: graph

  defp mark_group(graph, [next | queue], n) do
    {new_graph, neighbors} =
      case Map.get(graph, next) do
        :no_group ->
          {Map.put(graph, next, n),
           neighbors(next)
           |> Enum.filter(fn n -> Map.get(graph, n) != :free end)}

        m when m != n ->
          raise "Trying to mark an element from another group"

        _ ->
          {graph, []}
      end

    mark_group(new_graph, queue ++ neighbors, n)
  end

  defp create_graph(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, row_num}, graph ->
      row
      |> Enum.with_index()
      |> Enum.reduce(graph, fn
        {"1", col_num}, g -> Map.put(g, {row_num, col_num}, :no_group)
        {"0", col_num}, g -> Map.put(g, {row_num, col_num}, :free)
      end)
    end)
  end

  defp neighbors({row, col}) do
    top = if row > 0, do: [{row - 1, col}], else: []
    bottom = if row < 127, do: [{row + 1, col}], else: []
    left = if col > 0, do: [{row, col - 1}], else: []
    right = if col < 127, do: [{row, col + 1}], else: []
    top ++ bottom ++ left ++ right
  end
end
