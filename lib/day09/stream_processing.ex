defmodule Day09.StreamProcessing do
  def part1() do
    with {:ok, input} <- File.read("priv/day09/input.txt") do
      total_score(input)
    end
  end

  def part2() do
    with {:ok, input} <- File.read("priv/day09/input.txt") do
      garbage_count(input)
    end
  end

  def total_score(input) do
    input
    |> process_stream()
    |> elem(2)
  end

  def garbage_count(input) do
    input
    |> process_stream()
    |> elem(3)
  end

  defp process_stream(input) do
    input
    |> String.graphemes()
    |> Enum.reduce({:reading, 0, 0, 0}, fn c, {state, current_val, sum, garbage} ->
      case {state, c} do
        {:reading, "{"} -> {:reading, current_val + 1, sum, garbage}
        {:reading, "}"} -> {:reading, current_val - 1, sum + current_val, garbage}
        {:reading, "<"} -> {:garbage, current_val, sum, garbage}
        {:garbage, "<"} -> {:garbage, current_val, sum, garbage + 1}
        {:garbage, "!"} -> {:skip, current_val, sum, garbage}
        {:skip, _} -> {:garbage, current_val, sum, garbage}
        {:garbage, ">"} -> {:reading, current_val, sum, garbage}
        {:garbage, _} -> {:garbage, current_val, sum, garbage + 1}
        _ -> {:reading, current_val, sum, garbage}
      end
    end)
  end
end
