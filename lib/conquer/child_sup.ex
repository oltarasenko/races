defmodule ChildSup do
  @moduledoc """
  One for one supervisor
  """
  use Supervisor

  import Supervisor.Spec

  def start_link() do
    Supervisor.start_link(__MODULE__, [])
  end

  @doc """
  This is the callback from `start_link` which initialises the Supervisor.
  """
  def init(_args) do
    child_spec = [
      # %{
      #   id: Worker,
      #   start: {Worker, :start_link, [queue_name]},
      #   restart: :temporary,
      #   type: :worker,
      #   shutdown: 5000
      # },
      %{
        id: TrappedWorker,
        start: {TrappedWorker, :start_link, []},
        restart: :temporary,
        type: :worker,
        shutdown: 5000
      }
    ]

    Supervisor.init(child_spec, strategy: :one_for_one)
    # children = [
    #   worker(TrappedWorker, [queue_name]),
    #   worker(Worker, [queue_name])
    #   # worker(InflowNet.Core.WorkQueue.Keeper, [queue_name]),
    #   # worker(InflowNet.Core.WorkQueue, [queue_name])
    # ]

    # supervise(children, strategy: :one_for_one)
  end
end
