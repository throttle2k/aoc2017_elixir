defmodule Day21.FractalArt do
  defmodule Grid do
    defstruct [:pixels, :size, :h_offset, :v_offset]
  end

  @input ".#./..#/###"

  def part1() do
    with {:ok, input} <- File.read("priv/day21/input.txt") do
      part1_with_input(input, 5)
    end
  end

  def part2() do
    with {:ok, input} <- File.read("priv/day21/input.txt") do
      part1_with_input(input, 18)
    end
  end

  def part1_with_input(input, iterations) do
    grid =
      input
      |> parse()
      |> enhance(to_grid(@input), iterations)

    grid.pixels
    |> Enum.filter(fn {_pos, v} -> v == :on end)
    |> Enum.count()
  end

  defp enhance(rules, grid, iterations)
  defp enhance(_rules, grid, 0), do: grid

  defp enhance(rules, grid, n) do
    enhanced_grid =
      grid
      |> split()
      |> Enum.map(&get_enhancement(&1, rules))
      |> join()

    enhance(rules, enhanced_grid, n - 1)
  end

  defp split(%Grid{size: 2} = grid), do: [grid]
  defp split(%Grid{size: 3} = grid), do: [grid]

  defp split(%Grid{} = grid) do
    new_size = if rem(grid.size, 2) == 0, do: 2, else: 3

    split_count = div(grid.size, new_size)

    for v_offset <- 0..(split_count - 1), h_offset <- 0..(split_count - 1) do
      {v_offset, h_offset}
      start_row = v_offset * new_size
      start_col = h_offset * new_size

      sub_pixels =
        for row <- 0..(new_size - 1),
            col <- 0..(new_size - 1),
            into: %{} do
          global_pos = {start_row + row, start_col + col}
          value = Map.fetch!(grid.pixels, global_pos)
          {{row, col}, value}
        end

      %Grid{pixels: sub_pixels, size: new_size, h_offset: h_offset, v_offset: v_offset}
    end
  end

  defp join(grids) when length(grids) == 1, do: Enum.at(grids, 0)

  defp join([first | _] = grids) do
    grid_size = first.size
    split_count = grids |> length() |> :math.sqrt() |> trunc()
    new_size = split_count * grid_size

    new_pixels =
      for grid <- grids,
          {{row, col}, v} <- grid.pixels,
          into: %{} do
        global_row = row + grid.v_offset * grid_size
        global_col = col + grid.h_offset * grid_size
        {{global_row, global_col}, v}
      end

    %Grid{size: new_size, h_offset: 0, v_offset: 0, pixels: new_pixels}
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&parse_line/1)
    |> Enum.into(%{})
  end

  defp parse_line(line) do
    [from, to] = String.split(line, " => ", trim: true)
    from_grid = to_grid(from)
    to_grid_result = to_grid(to)

    variants = generate_variants(from_grid)

    Enum.map(variants, fn variant -> {grid_to_string(variant), to_grid_result} end)
  end

  defp generate_variants(grid) do
    degree_90_grid = rotate(grid)
    degree_180_grid = rotate(degree_90_grid)
    degree_270_grid = rotate(degree_180_grid)
    rotations = [grid, degree_90_grid, degree_180_grid, degree_270_grid]
    mirrored = Enum.map(rotations, &mirror/1)

    (rotations ++ mirrored)
    |> Enum.uniq_by(&grid_to_string/1)
  end

  defp get_enhancement(%Grid{} = grid, rules) do
    grid_as_string = grid_to_string(grid)
    enhanced_grid = Map.fetch!(rules, grid_as_string)
    %{enhanced_grid | v_offset: grid.v_offset, h_offset: grid.h_offset}
  end

  defp rotate(%Grid{} = grid) do
    grid
    |> mirror()
    |> transpose()
  end

  defp mirror(%Grid{size: size} = grid) do
    from = for row <- 0..(size - 1), col <- 0..(size - 1), do: {row, col}
    to = for row <- 0..(size - 1), col <- (size - 1)..0//-1, do: {row, col}

    new_pixels =
      from
      |> Enum.zip(to)
      |> Enum.map(fn {from, to} ->
        value = Map.get(grid.pixels, from)
        {to, value}
      end)
      |> Enum.into(%{})

    %{grid | pixels: new_pixels}
  end

  defp transpose(%Grid{size: size} = grid) do
    from = for row <- 0..(size - 1), col <- 0..(size - 1), do: {row, col}
    to = for row <- 0..(size - 1), col <- 0..(size - 1), do: {col, row}

    new_pixels =
      from
      |> Enum.zip(to)
      |> Enum.map(fn {from, to} ->
        value = Map.get(grid.pixels, from)
        {to, value}
      end)
      |> Enum.into(%{})

    %{grid | pixels: new_pixels}
  end

  defp grid_to_string(%Grid{size: size} = grid) do
    for row <- 0..(size - 1) do
      for col <- 0..(size - 1) do
        grid.pixels
        |> Map.get({row, col})
        |> then(fn
          :off -> "."
          :on -> "#"
        end)
      end
      |> Enum.join()
    end
    |> Enum.join("/")
  end

  defp to_grid(string, h_offset \\ 0, v_offset \\ 0) do
    string
    |> String.split("/", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, rownum}, pixels ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(pixels, fn
        {".", colnum}, pixels -> Map.put(pixels, {rownum, colnum}, :off)
        {"#", colnum}, pixels -> Map.put(pixels, {rownum, colnum}, :on)
      end)
    end)
    |> then(fn pixels ->
      %Grid{
        pixels: pixels,
        size: pixels |> map_size() |> :math.sqrt() |> trunc(),
        h_offset: h_offset,
        v_offset: v_offset
      }
    end)
  end
end
