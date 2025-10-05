defmodule Day23.CoprocessorConflagration.Instruction do
  def parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> parse()
  end

  def parse(["set", register, to]), do: {:set, register, parse_value(to)}
  def parse(["sub", register, to]), do: {:sub, register, parse_value(to)}
  def parse(["mul", register, to]), do: {:mul, register, parse_value(to)}
  def parse(["jnz", check, to]), do: {:jnz, parse_value(check), parse_value(to)}

  defp parse_value(s) do
    case Integer.parse(s) do
      {num, _} -> num
      :error -> s
    end
  end
end
