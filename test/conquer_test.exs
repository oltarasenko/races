defmodule ConquerTest do
  use ExUnit.Case
  use PropCheck
  use PropCheck.StateM

  property "My dear races", [:verbose, numtests: 100] do
    forall cmds <- parallel_commands(__MODULE__) do
      ParentSup.start_link()
      {history, state, result} = run_parallel_commands(__MODULE__, cmds)
      ParentSup.stop()

      (result == :ok)
      |> aggregate(command_names(cmds))
      |> when_fail(
        IO.puts("""
        History: #{inspect(history)}
        State: #{inspect(state)}
        Result: #{inspect(result)}
        """)
      )
    end
  end

  def initial_state(), do: %{children: 0}

  def command(_state) do
    frequency([
      {2, {:call, ParentSup, :start_child, []}},
      {1, {:call, ParentSup, :terminate_child, []}}
    ])
  end

  def precondition(%{children: 0}, {:call, ParentSup, :terminate_child, []}) do
    false
  end

  def precondition(_state, {:call, _mod, _fun, _args}) do
    true
  end

  def next_state(state = %{children: children}, _res, {:call, ParentSup, :start_child, []}) do
    %{state | children: children + 1}
  end

  def next_state(state = %{children: children}, _res, {:call, ParentSup, :terminate_child, []}) do
    %{state | children: children - 1}
  end

  def next_state(state, _res, {:call, _mod, _fun, _args}) do
    state
  end

  def postcondition(_state, {:call, ParentSup, :start_child, []}, {:ok, _pid}) do
    true
  end

  def postcondition(_state, {:call, ParentSup, :terminate_child, []}, :ok) do
    true
  end

  def postcondition(_state, {:call, _mod, _fun, _args}, res) do
    IO.inspect(res, label: :result_failed)
    false
  end
end
