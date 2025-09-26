defmodule Day04.HighEntropyPassphrases do
  def part1() do
    IO.inspect(File.cwd!())

    with {:ok, input} <- File.read("priv/day04/input.txt") do
      input
      |> String.split("\n")
      |> Enum.filter(fn s -> s != "" end)
      |> Enum.filter(&valid?/1)
      |> Enum.count()
    end
  end

  def valid?(pass) do
    pass
    |> String.split(" ")
    |> Enum.frequencies()
    |> Enum.all?(fn {_s, count} -> count == 1 end)
  end

  def part2() do
    IO.inspect(File.cwd!())

    with {:ok, input} <- File.read("priv/day04/input.txt") do
      input
      |> String.split("\n")
      |> Enum.filter(fn s -> s != "" end)
      |> Enum.filter(&(not anagrams_present?(&1)))
      |> Enum.count()
    end
  end

  def anagrams_present?(pass) do
    pass
    |> String.split(" ")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.frequencies/1)
    |> then(&do_anagrams_present?(&1))
  end

  def do_anagrams_present?([_]), do: false
  def do_anagrams_present?([char_freq1, char_freq2]), do: char_freq1 == char_freq2

  def do_anagrams_present?([char_freq1 | [char_freq2 | rest]]) do
    do_anagrams_present?([char_freq1, char_freq2]) or
      do_anagrams_present?([char_freq1 | rest]) or
      do_anagrams_present?([char_freq2 | rest])
  end
end
