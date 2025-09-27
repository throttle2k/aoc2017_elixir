defmodule Day08.Registers do
  defmodule Instruction do
    defstruct [:on_register, :operation, :amount, :cond_register, :cond_relation, :cond_value]

    def parse_operation("inc"), do: :inc
    def parse_operation("dec"), do: :dec

    def parse_cond_relation(">"), do: :gt
    def parse_cond_relation("<"), do: :lt
    def parse_cond_relation("=="), do: :eq
    def parse_cond_relation(">="), do: :gte
    def parse_cond_relation("<="), do: :lte
    def parse_cond_relation("!="), do: :ne

    def parse_cond_value(n), do: String.to_integer(n)

    def parse_amount(n), do: String.to_integer(n)
  end

  def part1() do
    with {:ok, input} <- File.read("priv/day08/input.txt") do
      {registers, instructions} = parse(input)
      registers = run(instructions, registers)

      find_largest_value(registers)
    end
  end

  def part2() do
    with {:ok, input} <- File.read("priv/day08/input.txt") do
      {registers, instructions} = parse(input)
      {_registers, stats} = run_with_stats(instructions, registers, %{})

      stats[:max_value]
    end
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce({%{}, []}, fn line, {registers, instructions} ->
      ins = parse_line(line)

      updated_registers =
        Enum.reduce([ins.on_register, ins.cond_register], registers, fn reg, acc ->
          Map.update(acc, reg, 0, fn _ -> 0 end)
        end)

      {updated_registers, [ins | instructions]}
    end)
    |> then(fn {registers, reversed_instructions} ->
      {registers, Enum.reverse(reversed_instructions)}
    end)
  end

  defp parse_line(line) do
    [on_register, operation, amount, _, cond_register, cond_relation, cond_value] =
      String.split(line)

    %Instruction{
      on_register: on_register,
      operation: Instruction.parse_operation(operation),
      amount: Instruction.parse_amount(amount),
      cond_register: cond_register,
      cond_relation: Instruction.parse_cond_relation(cond_relation),
      cond_value: Instruction.parse_cond_value(cond_value)
    }
  end

  def run([], registers), do: registers

  def run([instruction | rest], registers) do
    updated_registers =
      if eval_condition(registers, instruction),
        do: apply_operation(registers, instruction),
        else: registers

    run(rest, updated_registers)
  end

  def run_with_stats([], registers, stats), do: {registers, stats}

  def run_with_stats([instruction | rest], registers, stats) do
    updated_registers =
      if eval_condition(registers, instruction),
        do: apply_operation(registers, instruction),
        else: registers

    updated_stats =
      Map.update(stats, :max_value, -1_000_000, fn prev ->
        max(prev, find_largest_value(updated_registers))
      end)

    run_with_stats(rest, updated_registers, updated_stats)
  end

  defp apply_operation(registers, instruction),
    do:
      apply_operation(
        registers,
        instruction.on_register,
        instruction.operation,
        instruction.amount
      )

  defp apply_operation(registers, register, :inc, amount),
    do: Map.update!(registers, register, fn prev -> prev + amount end)

  defp apply_operation(registers, register, :dec, amount),
    do: Map.update!(registers, register, fn prev -> prev - amount end)

  defp eval_condition(registers, instruction),
    do:
      eval_condition(
        registers,
        instruction.cond_register,
        instruction.cond_relation,
        instruction.cond_value
      )

  defp eval_condition(registers, register, :gt, value), do: registers[register] > value
  defp eval_condition(registers, register, :lt, value), do: registers[register] < value
  defp eval_condition(registers, register, :eq, value), do: registers[register] == value
  defp eval_condition(registers, register, :gte, value), do: registers[register] >= value
  defp eval_condition(registers, register, :lte, value), do: registers[register] <= value
  defp eval_condition(registers, register, :ne, value), do: registers[register] != value

  def find_largest_value(registers) do
    registers
    |> Enum.max_by(fn {_reg, val} -> val end)
    |> elem(1)
  end
end
