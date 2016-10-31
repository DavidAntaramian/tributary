defmodule Tributary.Mixfile do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/davidantaramian/tributary"

  def project do
    [app: :tributary,
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package,
     name: "Tributary for Ecto",
     version: @version,
     docs: [source_ref: "v#{@version}", main: "Tributary"],
     source_url: @source_url,
     homepage_url: @source_url,
     description: """
     A simple stream generation library for Ecto queries that facilitates
     more efficient paging of queries both in the database and in your
     Ecto-reliant applicaton.
     """
   ]
  end

  def application do
    [applications: applications(Mix.env)]
  end

  defp applications(:test), do: [:postgrex, :ecto, :logger]
  defp applications(_), do: [:ecto, :logger]

  defp deps do
    [{:ecto, "~> 2.0"},
     {:earmark, "~> 0.1", only: [:dev, :docs]},
     {:ex_doc, "~> 0.10", only: [:dev, :docs]},
     {:postgrex, "~> 0.12", optional: true}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp package do
    [maintainers: ["David Antaramian"],
     licenses: ["MIT"],
     links: %{github: @source_url},
     files: ~w(lib mix.exs README.md LICENSE.md)
    ]
  end
end
