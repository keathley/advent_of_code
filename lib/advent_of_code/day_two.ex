defmodule AdventOfCode.DayTwo do
  def part_one(spreadsheet) do
    checksum(spreadsheet, &Enum.min_max/1, fn {min, max} -> max - min end)
  end

  def part_two(spreadsheet) do
    checksum(spreadsheet, &evenly_divisible/1, fn {a, b} -> b / a end)
  end

  def evenly_divisible(list) do
    list
    |> Enum.with_index
    |> Enum.flat_map(fn ({x, i}) ->
      list
      |> List.delete_at(i)
      |> Enum.map(fn y -> {x, y, rem(y, x)} end)
    end)
    |> Enum.filter(fn {_, _, r} -> r == 0 end)
    |> Enum.map(fn {x, y, _} -> {x, y} end)
    |> List.first
  end

  def checksum(spreadsheet, selector, aggregate) do
    spreadsheet
    |> String.split("\n", trim: true)
    |> Enum.map(& String.split(&1))
    |> Enum.map(fn is -> Enum.map(is, &String.to_integer/1) end)
    |> Enum.map(& selector.(&1))
    |> Enum.map(& aggregate.(&1))
    |> Enum.sum
  end
end
