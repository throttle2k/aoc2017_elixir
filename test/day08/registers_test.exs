defmodule Day08.RegistersTest do
  use ExUnit.Case, async: true
  alias Day08.Registers

  test "part1 - find largest value" do
    input = """
    b inc 5 if a > 1
    a inc 1 if b < 5
    c dec -10 if a >= 1
    c inc -20 if c == 10
    """

    {registers, instructions} = Registers.parse(input)
    registers = Registers.run(instructions, registers)

    assert Registers.find_largest_value(registers) == 1
  end

  test "part2 - find largest value during execution" do
    input = """
    b inc 5 if a > 1
    a inc 1 if b < 5
    c dec -10 if a >= 1
    c inc -20 if c == 10
    """

    {registers, instructions} = Registers.parse(input)
    {_registers, stats} = Registers.run_with_stats(instructions, registers, %{})

    assert stats[:max_value] == 10
  end
end
