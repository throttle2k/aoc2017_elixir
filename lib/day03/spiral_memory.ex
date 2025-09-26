defmodule Day03.SpiralMemory do
  @input 325_489

  def part1(input \\ @input) do
    input
    |> walk()
    |> Map.filter(fn {_k, v} -> v == input end)
    |> Enum.map(fn {k, _v} -> k end)
    |> Enum.at(0)
    |> Tuple.to_list()
    |> Enum.map(&abs/1)
    |> Enum.sum()
  end

  def part2(input \\ @input) do
    input
    |> walk(fn positions, pos, _val ->
      surrounding_val = neighbors(pos)

      surrounding_val
      |> Enum.map(&Map.get(positions, &1, 0))
      |> Enum.sum()
    end)
    |> Enum.filter(fn {_k, v} -> v >= input end)
    |> Enum.map(fn {_k, v} -> v end)
    |> Enum.sort_by(fn v -> v end)
    |> Enum.at(0)
  end

  def walk(input, calculator \\ fn _positions, _pos, val -> val + 1 end) do
    do_step(%{{0, 0} => 1}, {0, 0}, 1, 1, 2, :east, input, calculator)
  end

  def do_step(positions, prev_pos, val, num_steps, 0, direction, target, calculator) do
    do_step(positions, prev_pos, val, num_steps + 1, 2, direction, target, calculator)
  end

  def do_step(positions, _prev_pos, val, _num_steps, _count, _direction, target, _calculator)
      when val > target,
      do: positions

  def do_step(positions, prev_pos, val, num_steps, count, direction, target, calculator) do
    {new_pos, new_val, new_positions} =
      1..num_steps
      |> Enum.reduce({prev_pos, val, positions}, fn _, {last_pos, last_val, acc} ->
        new_pos = move(last_pos, direction)
        new_val = calculator.(acc, new_pos, last_val)
        {new_pos, new_val, Map.put(acc, new_pos, new_val)}
      end)

    new_direction = turn(direction)

    do_step(
      new_positions,
      new_pos,
      new_val,
      num_steps,
      count - 1,
      new_direction,
      target,
      calculator
    )
  end

  defp move({prev_row, prev_col}, :east), do: {prev_row, prev_col + 1}
  defp move({prev_row, prev_col}, :north), do: {prev_row - 1, prev_col}
  defp move({prev_row, prev_col}, :west), do: {prev_row, prev_col - 1}
  defp move({prev_row, prev_col}, :south), do: {prev_row + 1, prev_col}

  defp turn(:east), do: :north
  defp turn(:north), do: :west
  defp turn(:west), do: :south
  defp turn(:south), do: :east

  defp neighbors({row, col}) do
    for d_row <- -1..1//1, d_col <- -1..1//1, {d_row, d_col} != {0, 0} do
      {row + d_row, col + d_col}
    end
  end
end
