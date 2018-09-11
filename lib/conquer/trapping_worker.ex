defmodule TrappedWorker do
  @moduledoc """
  Executes given commands and returns a result to a process specified in execute function signature
  """
  require Logger
  use GenServer

  def start_link() do
    GenServer.start(__MODULE__, :ignored)
  end

  def init(:ignored) do
    IO.puts("Starting child...")
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

  def handle_info(msg, state) do
    IO.puts("...!!! Unexpected message: #{inspect(msg)}")
    {:noreply, state}
  end

  def terminate(reason, state) do
    IO.puts("[error] Terminated worker (trapping)")
  end
end
