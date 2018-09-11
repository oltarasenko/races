defmodule Worker do
  @moduledoc """
  Executes given commands and returns a result to a process specified in execute function signature
  """
  require Logger
  use GenServer

  def start_link(queue) do
    GenServer.start(__MODULE__, [queue])
  end

  def init(queue) do
    Process.send_after(self(), :stop_me, 500)
    {:ok, %{}}
  end

  def handle_info(:stop_me, state) do
    Process.exit(self(), :random)
    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.puts("...!!!Unexpected message: #{inspect(msg)}")
    {:noreply, state}
  end

  def terminate(reason, state) do
    IO.puts("[error] Terminated worker (raw)")
  end
end
