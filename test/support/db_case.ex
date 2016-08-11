defmodule DBCase do
  use ExUnit.CaseTemplate
  
  using do
    quote do
      import Ecto.Query
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Tributary.Repo)
  end
end
