defmodule Day10.KnotHash do
  import Bitwise

  @input_elements Range.to_list(0..255)
  @input_lengths "14,58,0,116,179,16,1,104,2,254,167,86,255,55,122,244"

  @standard_suffix "17,31,73,47,23"

  def part1(lengths \\ @input_lengths, elements \\ @input_elements) do
    elements_tuple = List.to_tuple(elements)

    lengths_list =
      lengths
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    process(elements_tuple, lengths_list)
    |> elem(0)
    |> product()
  end

  def part2(lengths \\ @input_lengths, elements \\ @input_elements) do
    elements_tuple = List.to_tuple(elements)

    lengths_list =
      lengths
      |> String.trim()
      |> String.to_charlist()
      |> Enum.concat(
        @standard_suffix
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      )

    1..64
    |> Enum.reduce({elements_tuple, 0, 0}, fn _, {elements, pos, skip} ->
      process(elements, lengths_list, pos, skip)
    end)
    |> elem(0)
    |> Tuple.to_list()
    |> Enum.chunk_every(16)
    |> Enum.map(fn chunk ->
      Enum.reduce(chunk, 0, fn num, acc -> bxor(acc, num) end)
    end)
    |> Enum.map(fn dec ->
      dec
      |> Integer.to_string(16)
      |> String.downcase()
      |> String.pad_leading(2, "0")
    end)
    |> Enum.join()
  end

  defp product(elements) do
    elem(elements, 0) * elem(elements, 1)
  end

  defp process(elements, lengths, start_pos \\ 0, start_skip_size \\ 0) do
    lengths
    |> Enum.reduce({elements, start_pos, start_skip_size}, fn length,
                                                              {elements, current_pos, skip_size} ->
      updated_elements = reverse(elements, current_pos, current_pos + length - 1)

      new_pos = rem(current_pos + length + skip_size, tuple_size(elements))

      {updated_elements, new_pos, skip_size + 1}
    end)
  end

  defp reverse(elements, from, to) when to <= from, do: elements

  defp reverse(elements, from, to) do
    sanified_from = rem(from, tuple_size(elements))
    from_val = elem(elements, sanified_from)
    sanified_to = rem(to, tuple_size(elements))
    to_val = elem(elements, sanified_to)

    updated_elements =
      elements
      |> put_elem(sanified_to, from_val)
      |> put_elem(sanified_from, to_val)

    reverse(updated_elements, from + 1, to - 1)
  end
end
