defmodule AdventOfCode.DayFour do
  def part_one(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(&valid?/1)
    |> Enum.filter(& &1)
    |> Enum.count
  end

  def valid?(words) do
    words
    |> Enum.uniq
    |> Enum.count == Enum.count(words)
  end
end
