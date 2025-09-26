defmodule Day02.CorruptionChecksumTest do
  use ExUnit.Case, async: true
  alias Day02.CorruptionChecksum

  test "part1 - spreadsheet checksum" do
    assert CorruptionChecksum.part1("""
           5\t1\t9\t5
           7\t5\t3
           2\t4\t6\t8
           """) == 18
  end

  test "part2 - spreadsheet checksum" do
    assert CorruptionChecksum.part2("""
           5\t9\t2\t8
           9\t4\t7\t3
           3\t8\t6\t5
           """) == 9
  end
end
