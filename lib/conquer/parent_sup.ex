defmodule ParentSup do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child() do
    Supervisor.start_child(__MODULE__, [])
  end

  def stop() do
    Supervisor.stop(__MODULE__)
  end

  def terminate_child() do
    case Supervisor.which_children(__MODULE__) do
      [] ->
        :ok

      l ->
        {_id, pid, _type, _mod} = Enum.random(l)
        IO.puts("Terminating: #{inspect(pid)}")
        Supervisor.terminate_child(__MODULE__, pid)
    end
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
