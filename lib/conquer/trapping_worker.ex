defmodule TrappedWorker do
  @moduledoc """
  Executes given commands and returns a result to a process specified in execute function signature
  """
  require Logger
  use GenServer

  def start_link(queue) do
    GenServer.start(__MODULE__, [queue])
  end

  def init(queue) do
    Process.flag(:trap_exit, true)
    Process.send_after(self(), {:set_link, queue}, 100)
    Process.send_after(self(), :stop_me, 500)
    {:ok, %{}}
  end

  def handle_info(:stop_me, state) do
    IO.puts("[error] Exit worker...")
    Process.exit(self(), :random)
    {:noreply, state}
  end

  def handle_info({:set_link, queue}, state) do
    set_link(queue, 10)
    # [{pid, _}] = Registry.lookup(MyReg, {:worker, queue})

    # Process.link(pid)
    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.puts("...!!!Unexpected message: #{inspect(msg)}")
    {:noreply, state}
  end

  def terminate(reason, state) do
    IO.puts("[error] Terminated worker (trapping)")
  end

  defp set_link(queue, 0) do
    IO.puts("Failed to set link")
  end

  defp set_link(queue, n) do
    case Registry.lookup(MyReg, {:worker, queue}) do
      [] ->
        :timer.sleep(100)
        set_link(queue, n - 1)

      [{pid, _}] ->
        IO.puts("LINK SET!")
        Process.link(pid)
    end
  end
end
