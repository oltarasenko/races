defmodule ParentSup do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(queue_name) do
    Supervisor.start_child(__MODULE__, [queue_name])
  end

  def terminate_child(pid) do
    Supervisor.terminate_child(__MODULE__, pid)
  end

  @impl true
  def init(_args) do
    child_spec = %{
      id: ChildSup,
      start: {ChildSup, :start_link, []},
      restart: :temporary,
      type: :supervisor,
      shutdown: :infinity
    }

    Supervisor.init([child_spec], strategy: :simple_one_for_one)
  end
end
