defmodule Day04.HighEntropyPassphrasesTest do
  use ExUnit.Case, async: true
  alias Day04.HighEntropyPassphrases

  test "aa bb cc dd ee is valid" do
    assert HighEntropyPassphrases.valid?("aa bb cc dd ee") == true
  end

  test "aa bb cc dd aa is not valid" do
    assert HighEntropyPassphrases.valid?("aa bb cc dd aa") == false
  end

  test "aa bb cc dd aaa is valid" do
    assert HighEntropyPassphrases.valid?("aa bb cc dd aaa") == true
  end

  test "abcde fghij is valid" do
    assert HighEntropyPassphrases.anagrams_present?("abcde fghij") == false
  end

  test "abcde xyz ecdab" do
    assert HighEntropyPassphrases.anagrams_present?("abcde xyz ecdab") == true
  end

  test "a ab abc abd abf abj" do
    assert HighEntropyPassphrases.anagrams_present?("a ab abc abd abf abj") == false
  end

  test "iiii oiii ooii oooi oooo" do
    assert HighEntropyPassphrases.anagrams_present?("iiii oiii ooii oooi oooo") == false
  end

  test "oiii ioii iioi iiio" do
    assert HighEntropyPassphrases.anagrams_present?("oiii ioii iioi iiio") == true
  end
end
