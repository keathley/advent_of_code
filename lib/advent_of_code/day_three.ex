defmodule AdventOfCode.DayThree do
  def part_one(label) do
    label
    |> to_point
    |> manhattan_distance(point(0, 0))
  end

  def part_two(n) do
    sum_square()
    |> Enum.find(& &1 > n)
  end

  def to_point(label) do
    graph()
    |> Enum.take(label)
    |> List.last
    |> point
  end

  def manhattan_distance(a, b) do
    abs(a.x - b.x) + abs(a.y - b.y)
  end

  def point({x, y}), do: %{x: x, y: y}
  def point(x, y), do: %{x: x, y: y}

  def up({a, b}), do: {a, b + 1}
  def down({a, b}), do: {a, b - 1}
  def left({a, b}), do: {a-1, b}
  def right({a, b}), do:  {a+1, b}

  def directions, do: [&right/1, &up/1, &left/1, &down/1]
  def diagonals, do: [
    fn({a, b}) -> {a+1, b+1} end,
    fn({a, b}) -> {a-1, b+1} end,
    fn({a, b}) -> {a+1, b-1} end,
    fn({a, b}) -> {a-1, b-1} end,
  ]

  def adjacents, do: directions() ++ diagonals()

  def infinite_list, do: Stream.iterate(1, &(&1 + 1))

  def replicate(elem, count) do
    Stream.repeatedly(fn -> elem end) |> Enum.take(count)
  end

  @doc """
  Generates an increasing infinite list

  ## Examples
    iex> AdventOfCode.DayThree.steps |> Enum.take(4)
    [1,1,2,2]
    iex> AdventOfCode.DayThree.steps |> Enum.take(10)
    [1,1,2,2,3,3,4,4,5,5]
  """
  def steps do
    infinite_list()
    |> Stream.zip(infinite_list())
    |> Stream.flat_map(fn {a, b} -> [a, b] end)
  end

  @doc """
  Infinite stream of movement functions that "walk" in a spiral pattern.
  A pattern would look like:
  `[right, up, left, left, down, down, right, right, right]`
  """
  def movements do
    steps()
    |> Stream.zip(Stream.cycle(directions()))
    |> Stream.map(fn {i, f} -> replicate(f, i) end)
    |> Stream.concat
  end

  @doc """
  Builds an infinite list representing coordinates in a spiral graph
  """
  def graph do
    g =
      movements()
      |> Stream.scan({0, 0}, fn(f, pos) -> f.(pos) end)

    Stream.concat([{0, 0}], g)
  end

  @doc """
  Generate a square in a spiral by summing adjacent squares.
  """
  def sum_square do
    graph()
    |> Stream.drop(1)
    |> Stream.scan(%{{0,0} => 1}, &set_value/2)
    |> Stream.map(& Enum.max_by(&1, fn({_, k}) -> k end))
    |> Stream.map(fn {_, k} -> k end)
  end

  def get_value(pos, m) do
    adjacents()
    |> Enum.map(fn f -> f.(pos) end)
    |> Enum.map(fn p -> Map.get(m, p, 0) end)
    |> Enum.sum
  end

  def set_value(pos, m) do
    Map.put(m, pos, get_value(pos, m))
  end
end
