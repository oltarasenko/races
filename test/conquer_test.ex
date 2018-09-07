defmodule ConquerTest do
  use ExUnit.Case

  test "greets the world" do
    :concuerror.run([{:module, :"Elixir.ConquerTest"}, {:test, :start_sup}])
    assert false
  end

  def start_sup() do
    {:ok, pid} = ParentSup.start_link()
  end

  # def test do
  #   {:ok, pid} = ParentSup.start_link()
  #   IO.puts("[error] pid: #{inspect(pid)}")
  # end
end
