defmodule Day05.TwistyTrampolines do
  def part1() do
    with {:ok, input} <- File.read("priv/day05/input.txt") do
      jump(input)
    end
  end

  def part2() do
    with {:ok, input} <- File.read("priv/day05/input.txt") do
      jump(input, fn prev_val ->
        cond do
          prev_val >= 3 -> prev_val - 1
          true -> prev_val + 1
        end
      end)
    end
  end

  def jump(input, incrementor \\ &(&1 + 1)) do
    input
    |> String.split("\n")
    |> Enum.filter(fn s -> s != "" end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {v, idx}, acc -> Map.put(acc, idx, String.to_integer(v)) end)
    |> then(&do_jump(&1, 0, 0, incrementor))
  end

  defp do_jump(state, current, count, incrementor) do
    case Map.get(state, current) do
      nil ->
        count

      n ->
        do_jump(
          Map.update!(state, current, incrementor),
          current + n,
          count + 1,
          incrementor
        )
    end
  end
end
