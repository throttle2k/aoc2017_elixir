defmodule Day17.Spinlock do
  @input 377

  def part1(input \\ @input) do
    1..2017
    |> Enum.reduce({0, {0}}, fn n, {current_pos, buffer} ->
      size = tuple_size(buffer)
      new_pos = rem(current_pos + input, size) + 1
      {new_pos, Tuple.insert_at(buffer, new_pos, n)}
    end)
    |> then(fn {current_pos, buffer} -> elem(buffer, current_pos + 1) end)
  end

  def part2(input \\ @input) do
    1..50_000_000
    |> Enum.reduce({0, {0}}, fn n, {current_pos, buffer} ->
      new_pos = rem(current_pos + input, n) + 1

      if new_pos == 1 do
        {new_pos, {0, n}}
      else
        {new_pos, buffer}
      end
    end)
    |> elem(1)
    |> elem(1)
  end
end
