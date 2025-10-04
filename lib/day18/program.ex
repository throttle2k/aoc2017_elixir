defmodule Day18.Duet.Part2.Program do
  use GenServer
  alias Day18.Duet.{Instruction, State}

  def start_link(id, instructions, parent) do
    GenServer.start_link(__MODULE__, {id, instructions, parent})
  end

  def set_partner(pid, other_pid) do
    GenServer.cast(pid, {:set_partner, other_pid})
  end

  def run_async(pid) do
    GenServer.cast(pid, :run)
  end

  def get_sent_count(pid) do
    GenServer.call(pid, :get_sent_count)
  end

  def get_status(pid) do
    GenServer.call(pid, :get_status)
  end

  def get_messages_in_transit(pid) do
    GenServer.call(pid, :get_messages_in_transit)
  end

  @impl true
  def init({id, instructions, parent}) do
    state = %State{
      id: id,
      instructions: instructions,
      ip: 0,
      registers: %{"p" => id},
      queue: :queue.new(),
      parent_pid: parent,
      sent_count: 0,
      waiting: false,
      messages_in_transit: 0
    }

    {:ok, state}
  end

  @impl true
  def handle_cast({:receive_value, val}, state) do
    new_queue = :queue.in(val, state.queue)
    new_state = %{state | queue: new_queue}

    if state.waiting do
      send(state.parent_pid, {:unblocked, self()})
      {:noreply, execute_program(%{new_state | waiting: false})}
    else
      {:noreply, new_state}
    end
  end

  def handle_cast({:set_partner, other_pid}, state) do
    {:noreply, %{state | other_pid: other_pid}}
  end

  def handle_cast(:run, state) do
    {:noreply, execute_program(state)}
  end

  def handle_cast(:message_delivered, state) do
    {:noreply, %{state | messages_in_transit: state.messages_in_transit - 1}}
  end

  @impl true
  def handle_call(:get_sent_count, _from, state) do
    {:reply, state.sent_count, state}
  end

  def handle_call(:get_status, _from, state) do
    if state.waiting do
      {:reply, :waiting, state}
    else
      {:reply, :running, state}
    end
  end

  def handle_call(:get_messages_in_transit, _from, state) do
    {:reply, state.messages_in_transit, state}
  end

  defp execute_program(%State{waiting: true} = state), do: state

  defp execute_program(%State{ip: ip, instructions: instructions} = state)
       when ip < 0 or ip >= length(instructions),
       do: send(state.parent_pid, {:finished, self()})

  defp execute_program(%State{} = state) do
    new_state = execute(Instruction.get_instruction(state), state)
    execute_program(new_state)
  end

  defp set_register(state, register, val) do
    %{state | registers: Map.put(state.registers, register, val)}
  end

  defp update_register(state, register, fun) do
    %{state | registers: Map.update(state.registers, register, 0, fun)}
  end

  defp advance_ip(state, offset \\ 1), do: %{state | ip: state.ip + offset}
  defp update_sent_count(state), do: %{state | sent_count: state.sent_count + 1}

  defp increase_message_in_transit(state),
    do: %{state | messages_in_transit: state.messages_in_transit + 1}

  defp set_queue(state, queue), do: %{state | queue: queue}

  defp set_waiting(state, val), do: %{state | waiting: val}

  defp execute({:set, register, value}, %State{} = state) do
    val = State.get_value(value, state.registers)

    state
    |> set_register(register, val)
    |> advance_ip()
    |> execute_program()
  end

  defp execute({:add, register, value}, %State{} = state) do
    val = State.get_value(value, state.registers)

    state
    |> update_register(register, fn prev -> prev + val end)
    |> advance_ip()
    |> execute_program()
  end

  defp execute({:mul, register, value}, %State{} = state) do
    val = State.get_value(value, state.registers)

    state
    |> update_register(register, fn prev -> prev * val end)
    |> advance_ip()
    |> execute_program()
  end

  defp execute({:mod, register, value}, %State{} = state) do
    val = State.get_value(value, state.registers)

    state
    |> update_register(register, fn prev -> rem(prev, val) end)
    |> advance_ip()
    |> execute_program()
  end

  defp execute({:jgz, v, value}, %State{} = state) do
    check = State.get_value(v, state.registers)
    val = State.get_value(value, state.registers)

    cond do
      check > 0 ->
        state
        |> advance_ip(val)
        |> execute_program()

      true ->
        state
        |> advance_ip()
        |> execute_program()
    end
  end

  defp execute({:snd, register}, %State{} = state) do
    val = State.get_value(register, state.registers)

    GenServer.cast(state.other_pid, {:receive_value, val})

    state
    |> increase_message_in_transit()
    |> update_sent_count()
    |> advance_ip()
    |> execute_program()
  end

  defp execute({:rcv, register}, %State{} = state) do
    case :queue.out(state.queue) do
      {{:value, val}, new_queue} ->
        GenServer.cast(state.other_pid, :message_delivered)

        state
        |> set_register(register, val)
        |> set_queue(new_queue)
        |> advance_ip()
        |> execute_program()

      {:empty, _} ->
        send(state.parent_pid, {:blocked, self()})
        state |> set_waiting(true)
    end
  end
end
