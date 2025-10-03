defmodule Day18.Duet.Instruction do
  alias Day18.Duet.State

  def parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> parse()
  end

  def get_instruction(%State{} = state) do
    state.instructions
    |> Enum.at(state.ip)
  end

  defp parse(["set", register, value]), do: {:set, register, value_or_registry(value)}
  defp parse(["add", register, value]), do: {:add, register, value_or_registry(value)}
  defp parse(["mul", register, value]), do: {:mul, register, value_or_registry(value)}
  defp parse(["mod", register, value]), do: {:mod, register, value_or_registry(value)}

  defp parse(["jgz", check, value]),
    do: {:jgz, value_or_registry(check), value_or_registry(value)}

  defp parse(["snd", register]), do: {:snd, register}
  defp parse(["rcv", register]), do: {:rcv, register}

  defp value_or_registry(s) do
    case Integer.parse(s) do
      {num, _} -> num
      :error -> s
    end
  end
end
