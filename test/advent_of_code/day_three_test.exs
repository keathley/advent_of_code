defmodule AdventOfCode.DayThreeTest do
  use ExUnit.Case, async: true
  doctest AdventOfCode.DayThree

  alias AdventOfCode.DayThree

  test "examples" do
    assert DayThree.distance(1) == 0
    assert DayThree.distance(12) == 3
    assert DayThree.distance(23) == 2
    assert DayThree.distance(1024) == 31

    assert DayThree.part_two(265149) == 266330
  end
end
