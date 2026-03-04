defmodule Q1.MixProject do
  use Mix.Project

  def project do
    [
      app: :q1,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def cli do
    [
      default_task: "run_quest"
    ]
  end

  defp aliases do
    [
      run_quest: [
        "run -e 'Q1.part1(\"../inputa.txt\") |> IO.puts(); Q1.part2(\"../inputb.txt\") |> IO.puts(); Q1.part3(\"../inputc.txt\") |> IO.puts()'"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
