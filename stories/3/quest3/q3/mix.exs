defmodule Q3.MixProject do
  use Mix.Project

  def project do
    [
      app: :q3,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def cli do
    [
      default_task: "all"
    ]
  end

  defp aliases do
    [
      part1: ["run -e 'IO.puts(Q3.solve(\"../inputa.txt\", :p1))'"],
      part2: ["run -e 'IO.puts(Q3.solve(\"../inputb.txt\", :p2))'"],
      part3: ["run -e 'IO.puts(Q3.solve(\"../inputc.txt\", :p3))'"],
      all: ["part1", "part2", "part3"]
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
