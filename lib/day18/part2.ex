defmodule Day18.Duet.Part2 do
  alias Day18.Duet.Part2.Program

  def run() do
    with {:ok, input} <- File.read("priv/day18/input.txt") do
      run_with_input(input)
    end
  end

  def run_with_input(input) do
    instructions =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&Day18.Duet.Instruction.parse_line/1)

    {time_in_microseconds, result} =
      :timer.tc(fn ->
        parent = self()

        {:ok, p0} = Program.start_link(0, instructions, parent)
        {:ok, p1} = Program.start_link(1, instructions, parent)

        Program.set_partner(p0, p1)
        Program.set_partner(p1, p0)

        Program.run_async(p0)
        Program.run_async(p1)

        wait_for_deadlock(p0, p1)

        Program.get_sent_count(p1)
      end)

    time_in_milliseconds = time_in_microseconds / 1000
    IO.puts("Execution time: #{time_in_milliseconds} ms")
    result
  end

  defp wait_for_deadlock(p0, p1, blocked \\ MapSet.new()) do
    receive do
      {:blocked, pid} ->
        new_blocked = MapSet.put(blocked, pid)

        if MapSet.size(new_blocked) == 2 do
          messages0 = Program.get_messages_in_transit(p0)
          messages1 = Program.get_messages_in_transit(p1)

          if messages0 == 0 and messages1 == 0 do
            :ok
          else
            wait_for_deadlock(p0, p1, new_blocked)
          end
        else
          wait_for_deadlock(p0, p1, new_blocked)
        end

      {:finished, _} ->
        :ok

      {:unblocked, pid} ->
        wait_for_deadlock(p0, p1, MapSet.delete(blocked, pid))
    end
  end
end
