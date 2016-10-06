defmodule TributaryTest do
  use DBCase

  alias Tributary.{Repo, Widget}

  defp create_widgets!(n) do
    1..n
    |> Enum.map(fn i ->
      %Widget{name: "Widget #{i}"} |> Repo.insert!
    end)
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

  test "stream with database options" do
    create_widgets!(100)

    stream = Repo.stream(Widget, chunk_size: 20, timeout: 20_000)
    assert Enum.count(stream) == 100

    names = Enum.map(stream, fn %{name: name} -> name end)
    assert ["Widget 1", "Widget 2", "Widget 3" | _] = names
    assert List.last(names) == "Widget 100"
  end
end
