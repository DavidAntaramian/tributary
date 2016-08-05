defmodule TributaryTest do
  use ExUnit.Case

  import Ecto.Query

  alias Tributary.{Repo, Widget}

  defp create_widgets!(n, attributes \\ %{}) do
    1..n
    |> Enum.map(fn i ->
      %Widget{name: "Widget #{i}"} |> Repo.insert!
    end)
  end

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(Tributary.Repo, :manual)

    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Tributary.Repo)
  end


  test "stream single chunk" do
    create_widgets!(10)

    stream = Repo.stream(Widget)
    assert Enum.count(stream) == 10

    names = Enum.map(stream, fn %{name: name} -> name end)
    assert ["Widget 1", "Widget 2", "Widget 3" | _] = names
    assert List.last(names) == "Widget 10"
  end

  test "stream multiple chunks" do
    create_widgets!(100)

    stream = Repo.stream(Widget, chunk_size: 20)
    assert Enum.count(stream) == 100

    names = Enum.map(stream, fn %{name: name} -> name end)
    assert ["Widget 1", "Widget 2", "Widget 3" | _] = names
    assert List.last(names) == "Widget 100"
  end

end
