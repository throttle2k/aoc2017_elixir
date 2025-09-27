defmodule Day09.StreamProcessingTest do
  use ExUnit.Case, async: true
  alias Day09.StreamProcessing

  test "part1 - score of {}" do
    assert StreamProcessing.total_score("{}") == 1
  end

  test "part1 - score of {{{}}}" do
    assert StreamProcessing.total_score("{{{}}}") == 6
  end

  test "part1 - score of {{},{}}" do
    assert StreamProcessing.total_score("{{},{}}") == 5
  end

  test "part1 - score of {{{},{},{{}}}}" do
    assert StreamProcessing.total_score("{{{},{},{{}}}}") == 16
  end

  test "part1 - score of {<a>,<a>,<a>,<a>}" do
    assert StreamProcessing.total_score("{<a>,<a>,<a>,<a>}") == 1
  end

  test "part1 - score of {{<ab>},{<ab>},{<ab>},{<ab>}}" do
    assert StreamProcessing.total_score("{{<ab>},{<ab>},{<ab>},{<ab>}}") == 9
  end

  test "part1 - score of {{<!!>},{<!!>},{<!!>},{<!!>}}" do
    assert StreamProcessing.total_score("{{<!!>},{<!!>},{<!!>},{<!!>}}") == 9
  end

  test "part1 - score of {{<a!>},{<a!>},{<a!>},{<ab>}}" do
    assert StreamProcessing.total_score("{{<a!>},{<a!>},{<a!>},{<ab>}}") == 3
  end
end
