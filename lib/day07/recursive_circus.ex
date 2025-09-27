defmodule Day07.RecursiveCircus do
  defmodule Program do
    defstruct [:weight, :above, :total_weight, :siblings]
  end

  def part1() do
    with {:ok, input} <- File.read("priv/day07/input.txt") do
      input
      |> parse()
      |> find_bottom()
    end
  end

  def part2() do
    graph =
      with {:ok, input} <- File.read("priv/day07/input.txt") do
        input
        |> parse()
      end

    bottom = find_bottom(graph)
    graph = process_siblings(graph, bottom)

    find_correct_weight(graph, bottom)
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, acc ->
      {name, program} = parse_program(line)
      Map.put(acc, name, program)
    end)
  end

  def process_siblings(graph, bottom_name) do
    do_process_siblings(graph, [bottom_name])
  end

  defp do_process_siblings(graph, []), do: graph

  defp do_process_siblings(graph, [first | rest]) do
    program = Map.get(graph, first)

    case program.above do
      [] ->
        do_process_siblings(graph, rest)

      siblings ->
        new_graph =
          siblings
          |> Enum.map(fn sibling -> {sibling, Map.get(graph, sibling)} end)
          |> Enum.map(fn {sibling, program} ->
            new_program = Map.put(program, :siblings, List.delete(siblings, sibling))
            {sibling, new_program}
          end)
          |> Enum.reduce(graph, fn {sibling, new_program}, acc ->
            Map.put(acc, sibling, new_program)
          end)

        do_process_siblings(new_graph, rest ++ siblings)
    end
  end

  defp parse_program(line) do
    {name_and_weight, above} = parse_name_and_maybe_above(line)
    [name, weight] = String.split(name_and_weight, " ")

    weight =
      weight
      |> String.trim_leading("(")
      |> String.trim_trailing(")")
      |> String.to_integer()

    {name, %Program{weight: weight, above: above}}
  end

  defp parse_name_and_maybe_above(line) do
    separator = " -> "

    if String.contains?(line, separator) do
      [nw, above_list] = String.split(line, separator)
      {nw, above_list |> String.trim() |> String.split(",") |> Enum.map(&String.trim/1)}
    else
      {line, []}
    end
  end

  def find_bottom(graph) do
    graph
    |> Enum.filter(fn {_name, %Program{} = p} -> not Enum.empty?(p.above) end)
    |> do_find_bottom()
    |> elem(0)
  end

  defp do_find_bottom([{current_name, _p} = current | rest]) do
    if Enum.any?(rest, &program_contains?(&1, current_name)) do
      do_find_bottom(rest ++ [current])
    else
      current
    end
  end

  defp program_contains?({_sub_name, sub_p}, p_name) do
    p_name in sub_p.above
  end

  defp process_weights(graph, for) do
    program = Map.get(graph, for)

    {new_graph, total_weight} =
      if Enum.empty?(program.above) do
        {graph, program.weight}
      else
        new_graph =
          program.above
          |> Enum.reduce(graph, fn p_name, acc ->
            process_weights(acc, p_name)
          end)

        new_program = Map.get(new_graph, for)

        new_weight =
          new_program.above
          |> Enum.map(fn p_name ->
            %Program{total_weight: w} = Map.get(new_graph, p_name)
            w
          end)
          |> Enum.sum()
          |> Kernel.+(program.weight)

        {new_graph, new_weight}
      end

    Map.update!(new_graph, for, fn _ ->
      Map.update!(program, :total_weight, fn _ -> total_weight end)
    end)
  end

  def find_correct_weight(graph, bottom) do
    process_weights(graph, bottom)
    |> find_wrong_program(bottom)
  end

  defp find_wrong_program(graph, bottom) do
    do_find_wrong_program(graph, bottom)
  end

  defp do_find_wrong_program(graph, current) do
    program = Map.get(graph, current)

    cond do
      Enum.empty?(program.above) ->
        program

      all_above_equals?(graph, program.above) ->
        sibling = Map.get(graph, Enum.at(program.siblings, 0))
        program.weight + sibling.total_weight - program.total_weight

      true ->
        different_above = find_different_program_above(graph, program.above)
        do_find_wrong_program(graph, different_above)
    end
  end

  defp all_above_equals?(graph, above) do
    [first | rest] =
      above
      |> Enum.map(&Map.get(graph, &1))
      |> Enum.map(fn %Program{total_weight: tw} -> tw end)

    Enum.all?(rest, &(&1 == first))
  end

  defp find_different_program_above(graph, above) do
    get_weight_map(graph, above)
    |> Enum.filter(fn {_k, v} -> length(v) == 1 end)
    |> Enum.map(fn {_k, v} -> v end)
    |> Enum.at(0)
    |> Enum.at(0)
  end

  defp get_weight_map(graph, above) do
    above
    |> Enum.map(fn name -> {name, Map.get(graph, name)} end)
    |> Enum.map(fn {name, %Program{total_weight: tw}} -> {name, tw} end)
    |> Enum.reduce(%{}, fn {name, total_weight}, acc ->
      Map.update(acc, total_weight, [name], fn prev -> [name | prev] end)
    end)
  end
end
