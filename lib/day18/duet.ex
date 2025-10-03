defmodule Day18.Duet do
  alias Day18.Duet.{Instruction, State}

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Instruction.parse_line/1)
    |> then(fn instructions ->
      %State{instructions: instructions, ip: 0, registers: %{}, waiting: false}
    end)
  end
end
