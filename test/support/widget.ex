defmodule Tributary.Widget do
  use Ecto.Schema

  import Ecto.Query

  schema "widgets" do
    field :name, :string

    timestamps
  end

end
