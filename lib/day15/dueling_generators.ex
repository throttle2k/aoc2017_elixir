defmodule Day15.DuelingGenerators do
  import Bitwise

  @input %{a_start: 591, b_start: 393}
  @a_factor 16807
  @b_factor 48271
  @divisor 2_147_483_647

  def part1(input \\ @input) do
    1..40_000_000
    |> Enum.reduce({{input.a_start, input.b_start}, 0}, fn _, {{a_gen, b_gen}, count} ->
      next_a = generate(a_gen, :a)
      next_b = generate(b_gen, :b)

      processed_a = band(next_a, 65535)
      processed_b = band(next_b, 65535)

      count = if processed_a == processed_b, do: count + 1, else: count

      {{next_a, next_b}, count}
    end)
    |> elem(1)
  end

  def part2(input \\ @input) do
    gen_a = fn prev ->
      next = rem(prev * @a_factor, @divisor)
      {next, next}
    end

    gen_b = fn prev ->
      next = rem(prev * @b_factor, @divisor)
      {next, next}
    end

    val_a = fn num -> rem(num, 4) == 0 end
    val_b = fn num -> rem(num, 8) == 0 end

    stream_a = stream(input.a_start, gen_a, val_a)
    stream_b = stream(input.b_start, gen_b, val_b)

    Stream.zip(stream_a, stream_b)
    |> Stream.take(5_000_000)
    |> Enum.count(fn {a, b} ->
      band(a, 65535) == band(b, 65535)
    end)
  end

  defp stream(initial_state, gen_function, val_function) do
    Stream.resource(
      fn -> initial_state end,
      fn state -> generate_valid(state, gen_function, val_function) end,
      fn _state -> :ok end
    )
  end

  defp generate_valid(state, gen_function, val_function) do
    {num, new_state} = gen_function.(state)

    if val_function.(num) do
      {[num], new_state}
    else
      generate_valid(new_state, gen_function, val_function)
    end
  end

  defp generate(start, :a), do: generate(start, @a_factor)
  defp generate(start, :b), do: generate(start, @b_factor)

  defp generate(start, factor) do
    rem(start * factor, @divisor)
  end
end
