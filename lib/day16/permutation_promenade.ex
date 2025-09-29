defmodule Day16.PermutationPromenade do
  def part1() do
    with {:ok, input} <- File.read("priv/day16/input.txt") do
      initial_state = generate_initial_state(16)

      input
      |> parse()
      |> dance(initial_state)
      |> state_to_string()
    end
  end

  def part2() do
    with {:ok, input} <- File.read("priv/day16/input.txt") do
      initial_state = generate_initial_state(16)

      input
      |> parse()
      |> repeated_dance(initial_state, 1_000_000_000)
      |> state_to_string()
    end
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&parse_move/1)
  end

  def state_to_string(%{} = state) do
    0..(map_size(state) - 1)
    |> Enum.map(&state[&1])
    |> Enum.join()
  end

  def generate_initial_state(size) do
    0..(size - 1)
    |> Enum.map(&{&1, <<?a + &1>>})
    |> Enum.into(%{})
  end

  defp find_cycle(moves, initial_state) do
    states = %{initial_state => 0}

    do_find_cycle(moves, initial_state, states, 1)
  end

  defp do_find_cycle(moves, state, seen_states, iteration) do
    new_state = dance(moves, state)

    case Map.get(seen_states, new_state) do
      nil ->
        do_find_cycle(moves, new_state, Map.put(seen_states, new_state, iteration), iteration + 1)

      first_seen ->
        iteration - first_seen
    end
  end

  def repeated_dance(moves, state, n) do
    cycle_length = find_cycle(moves, state)
    remaining = rem(n, cycle_length)

    do_repeated_dance(moves, state, remaining)
  end

  def do_repeated_dance(_, state, 0), do: state

  def do_repeated_dance(moves, state, n) do
    do_repeated_dance(moves, dance(moves, state), n - 1)
  end

  def dance(moves, %{} = inital_state) do
    moves
    |> Enum.reduce(inital_state, fn move, state ->
      execute(move, state)
    end)
  end

  defp parse_move(<<?s, qty::binary>>), do: {:spin, String.to_integer(qty)}

  defp parse_move(<<?x, rest::binary>>) do
    [from, to] = String.split(rest, "/")
    {:exchange, String.to_integer(from), String.to_integer(to)}
  end

  defp parse_move(<<?p, rest::binary>>) do
    [from, to] = String.split(rest, "/")
    {:partner, from, to}
  end

  defp execute({:spin, n}, state), do: spin(n, state)
  defp execute({:exchange, from, to}, state), do: exchange(from, to, state)
  defp execute({:partner, from, to}, state), do: partner(from, to, state)

  defp spin(n, %{} = state) do
    size = map_size(state)

    0..(size - 1)
    |> Enum.reduce(%{}, fn pos, new_state ->
      Map.put(new_state, rem(pos + n, size), state[pos])
    end)
  end

  defp exchange(from, to, state) do
    state
    |> Map.put(from, state[to])
    |> Map.put(to, state[from])
  end

  defp partner(from, to, state) do
    idx_from = find_index_of(state, from)
    idx_to = find_index_of(state, to)

    state
    |> Map.put(idx_from, state[idx_to])
    |> Map.put(idx_to, state[idx_from])
  end

  defp find_index_of(state, program) do
    state
    |> Enum.with_index()
    |> Enum.find(fn {{_pos, p}, _id} -> p == program end)
    |> elem(1)
  end
end
