defmodule Tributary do
  defmacro __using__(_) do
    quote do
      import Ecto.Query, only: [where: 3, limit: 3]
      import Ecto.Query.API, only: [field: 2]

      def stream(query, opts \\ []) do
        initial_key = Keyword.get(opts, :initial_key, 0)
        key_name = Keyword.get(opts, :key_name, :id)
        chunk_size = Keyword.get(opts, :chunk_size, 500)

        Stream.resource(fn -> {query, initial_key} end,
          fn {query, last_seen_key} ->
            results = query
              |> Ecto.Query.where([r], field(r, ^key_name) > ^last_seen_key)
              |> Ecto.Query.limit(^chunk_size) 
              |> __ENV__.module.all

            cond do
              Enum.count(results) > 0 ->
                last_key = results
                  |> Enum.reverse
                  |> Enum.at(0)
                  |> Map.get(key_name)
                
                {results, {query, last_key}}

              :otherwise ->
                {:halt, {query, last_seen_key}}
            end
          end,
          fn _ -> [] end)
      end
    end
  end
end
