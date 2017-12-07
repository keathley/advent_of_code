defmodule AdventOfCode.DaySeven do
  defmodule DAG do
    @initial %{}

    def build(vertices) do
      dag = :digraph.new

      Enum.each(vertices, fn {name, _, ds} ->
        :digraph.add_vertex(dag, name)
        Enum.each(ds, fn dn ->
          :digraph.add_vertex(dag, dn)
          :digraph.add_edge(dag, name, dn)
        end)
      end)

      dag
    end

    def root(dag) do
      dag
      |> toposort
      |> List.first
    end

    def toposort(dag), do: :digraph_utils.topsort(dag)
  end

  def part_one(list) do
    list
    |> parse_list
    |> DAG.build
    |> DAG.root
  end

  def part_two(list) do
    dag =
      list
      |> parse_list
      |> DAG.build

    root = DAG.root(dag)
    weights(dag, root)
  end

  def weights(dag, root) do
    neighbours = :digraph.out_neighbours(dag, root)
    weights(dag, root, neighbours, 0)
  end
  def weights(_dag, _v, [], weight), do: weight
  def weights(dag, v, [head | tail], weight) do
    weight + weights(dag, head, neighbors(dag, head)) + weights(dag, v, tail, weight)
  end

  def neighbors(dag, v), do: :digraph.out_neighbours(dag, v)

  def parse_list(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    line
    |> to_charlist
    |> tokenize
    |> parse
    |> normalize
  end

  def parse(tokens) do
    {:ok, program} = :list_parser.parse(tokens)
    program
  end

  def normalize({name, weight, descendants}) do
    {to_string(name), weight, Enum.map(descendants, &to_string/1)}
  end

  def tokenize(charlist) do
    {:ok, tokens, _} = :list_lexer.string(charlist)
    tokens
  end
end
