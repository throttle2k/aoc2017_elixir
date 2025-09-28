defmodule Day13.PacketScanners do
  defmodule State do
    defstruct [:scanners, :max_depth]

    def new({scanners, max_depth}) do
      %__MODULE__{scanners: scanners, max_depth: max_depth}
    end
  end

  def part1() do
    with {:ok, input} <- File.read("priv/day13/input.txt") do
      input
      |> parse()
      |> calculate_severity()
    end
  end

  def part2() do
    with {:ok, input} <- File.read("priv/day13/input.txt") do
      input
      |> parse()
      |> min_delay_to_pass()
    end
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(": ")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.reduce({%{}, 0}, fn [depth, range], {scanners, _max_depth} ->
      {Map.put(scanners, depth, {range, :inc, 0}), depth}
    end)
    |> then(&State.new(&1))
  end

  def calculate_severity(state) do
    traverse(state) |> elem(1)
  end

  def traverse(%State{scanners: scanners, max_depth: max_depth} = state) do
    0..max_depth
    |> Enum.reduce({state, 0, :safe}, fn current_depth, {curr_state, severity, safety} ->
      {new_severity, safety} =
        if caught?(curr_state, current_depth) do
          current_scanner_range =
            scanners
            |> Map.get(current_depth)
            |> elem(0)

          {severity + current_depth * current_scanner_range, :caught}
        else
          {severity, safety}
        end

      {step(curr_state), new_severity, safety}
    end)
  end

  def traverse_fail_fast(%State{scanners: scanners, max_depth: max_depth} = state) do
    0..max_depth
    |> Enum.reduce_while({state, 0, :safe}, fn current_depth, {curr_state, severity, safety} ->
      if caught?(curr_state, current_depth) do
        current_scanner_range =
          scanners
          |> Map.get(current_depth)
          |> elem(0)

        {:halt, {curr_state, severity + current_depth * current_scanner_range, :caught}}
      else
        {:cont, {step(curr_state), severity, safety}}
      end
    end)
  end

  def min_delay_to_pass(%State{} = state) do
    1..1_000_000_000
    |> Enum.reduce_while({state, 1}, fn _n, {curr_state, delay} ->
      new_state = step(curr_state)

      if traverse_fail_fast(new_state) |> elem(2) == :safe,
        do: {:halt, {new_state, delay}},
        else: {:cont, {new_state, delay + 1}}
    end)
    |> elem(1)
  end

  defp caught?(%State{scanners: scanners}, current_depth) do
    case scanners[current_depth] do
      nil -> false
      {_, _, current_range} -> current_range == 0
    end
  end

  defp step(%State{scanners: scanners} = state) do
    new_scanners =
      Enum.reduce(scanners, %{}, fn {depth, scanner}, acc ->
        Map.put(acc, depth, update_scanner(scanner))
      end)

    %{state | scanners: new_scanners}
  end

  defp update_scanner({range, :inc, current_range}) when current_range == range - 1,
    do: {range, :dec, current_range - 1}

  defp update_scanner({range, :inc, current_range}), do: {range, :inc, current_range + 1}
  defp update_scanner({range, :dec, current_range}) when current_range == 0, do: {range, :inc, 1}
  defp update_scanner({range, :dec, current_range}), do: {range, :dec, current_range - 1}
end
