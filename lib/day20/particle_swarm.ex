defmodule Day20.ParticleSwarm do
  def part1() do
    with {:ok, input} <- File.read("priv/day20/input.txt") do
      part1_with_input(input)
    end
  end

  def part1_with_input(input) do
    input
    |> parse()
    |> Enum.min_by(fn %{acceleration: a} ->
      :math.sqrt(:math.pow(a.x, 2) + :math.pow(a.y, 2) + :math.pow(a.z, 2))
    end)
    |> Map.get(:id)
  end

  def part2() do
    with {:ok, input} <- File.read("priv/day20/input.txt") do
      part2_with_input(input)
    end
  end

  def part2_with_input(input) do
    input
    |> parse()
    |> step(100)
    |> Enum.count()
  end

  defp step(particles, 0), do: particles

  defp step(particles, n) do
    particles
    |> Enum.map(&tick/1)
    |> Enum.reduce(%{}, fn p, acc ->
      Map.update(acc, p.position, [{p.id, p.velocity, p.acceleration}], fn prev ->
        [{p.id, p.velocity, p.acceleration} | prev]
      end)
    end)
    |> Enum.filter(fn {_k, v} -> length(v) == 1 end)
    |> Enum.map(fn {k, [v]} -> {k, v} end)
    |> Enum.map(fn {k, v} ->
      %{id: elem(v, 0), velocity: elem(v, 1), acceleration: elem(v, 2), position: k}
    end)
    |> then(&step(&1, n - 1))
  end

  defp tick(%{} = particle) do
    new_velocity = %{
      particle.velocity
      | x: particle.velocity.x + particle.acceleration.x,
        y: particle.velocity.y + particle.acceleration.y,
        z: particle.velocity.z + particle.acceleration.z
    }

    new_position = %{
      particle.position
      | x: particle.position.x + new_velocity.x,
        y: particle.position.y + new_velocity.y,
        z: particle.position.z + new_velocity.z
    }

    %{particle | position: new_position, velocity: new_velocity}
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce([], &parse_line/2)
  end

  defp parse_line({line, idx}, acc) do
    line
    |> String.split(", ", trim: true)
    |> then(fn [p, v, a] ->
      [
        %{
          id: idx,
          position: parse_vector(p),
          velocity: parse_vector(v),
          acceleration: parse_vector(a)
        }
        | acc
      ]
    end)
  end

  defp parse_vector(s) do
    s
    |> String.slice(3..(String.length(s) - 2))
    |> String.split(",", trim: true)
    |> then(fn [x, y, z] ->
      %{x: String.to_integer(x), y: String.to_integer(y), z: String.to_integer(z)}
    end)
  end
end
