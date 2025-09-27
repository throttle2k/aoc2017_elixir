defmodule Day06.MemoryReallocation do
  @input "5	1	10	0	1	7	13	14	3	12	8	10	7	12	0	6"

  def part1(input \\ @input) do
    input
    |> String.split("\t")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {s, idx}, acc -> Map.put(acc, idx, String.to_integer(s)) end)
    |> find_cycle([], 0)
    |> elem(1)
  end

  def part2(input \\ @input) do
    input
    |> String.split("\t")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {s, idx}, acc -> Map.put(acc, idx, String.to_integer(s)) end)
    |> find_cycle([], 0)
    |> elem(0)
    |> cycle_legth()
  end

  defp find_cycle(current_state, states, count) do
    if current_state in states do
      {[current_state | states], count}
    else
      find_cycle(redistribute(current_state), [current_state | states], count + 1)
    end
  end

  defp cycle_legth([repeated | rest]) do
    Enum.find_index(rest, &(&1 == repeated)) + 1
  end

  def redistribute(banks) do
    {max_bank, max_val} =
      banks
      |> Enum.max_by(fn {_l, v} -> v end)

    idx_limit = map_size(banks) - 1

    do_redistribute(
      Map.update!(banks, max_bank, fn _ -> 0 end),
      next_idx(max_bank, idx_limit),
      idx_limit,
      max_val
    )
  end

  defp do_redistribute(banks, _idx, _idx_limit, 0), do: banks

  defp do_redistribute(banks, idx, idx_limit, n) do
    new_banks = Map.update!(banks, idx, &(&1 + 1))

    do_redistribute(new_banks, next_idx(idx, idx_limit), idx_limit, n - 1)
  end

  defp next_idx(idx, idx_limit) do
    if idx >= idx_limit, do: 0, else: idx + 1
  end
end
