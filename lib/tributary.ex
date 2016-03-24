defmodule Tributary do
  import Ecto.Query, only: [where: 3, limit: 2]
  import Ecto.Query.API, only: [field: 2]
  
  defmacro __using__(_) do
    quote do

      def stream(query, opts \\ []) do
        initial_key = Keyword.get(opts, :initial_key, 0)
        key_name = Keyword.get(opts, :key_name, :id)
        chunk_size = Keywork.get(opts, :chunk_size, 500)

        Stream.resource(fn -> {query, initial_key} end,
          fn {query, last_seen_key} ->
            results = query
              |> where(field(c, key_name) > last_seen_key)
              |> limit(^chunk_size) 
              |> __ENV__.module.all

            cond do
              Enum.count(results) > 0 ->
                last_key = results
                  |> Enum.reverse
                  |> Enum.at(0)
                  |> Map.get(key_name)
                
                {results, {query, last_key}}

              :otherwise ->
                {:halt, {query, last_seen_id}}
            end
          end,
          fn _ -> [] end)
      end
    end
  end
end
