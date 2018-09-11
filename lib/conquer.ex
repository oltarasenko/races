defmodule Conquer do
  @moduledoc """
  Documentation for Conquer.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Conquer.hello
      :world

  """
  def hello do
    :world
  end

  def do_test() do
    :concuerror.run([
      {:module, :"Elixir.Conquer"},
      {:test, :start_sup},
      :keep_going,
      {:ignore_error, :crash},
      {:show_races, true}
    ])

    # :concuerror.run([{:module, :"Elixir.Conquer"}, {:test, :start_sup}])
  end

  # def start_sup() do
  #   {:ok, _pid} = ParentSup.start_link()
  #   # {:ok, _} = Registry.start_link(keys: :unique, name: MyReg)

  #   pids =
  #     Enum.map(1..15, fn x ->
  #       {:ok, pid} = ParentSup.start_child(x)
  #       pid
  #     end)

  #   Enum.each(pids, fn pid ->
  #     ParentSup.terminate_child(pid)
  #   end)
  # end
end
