defmodule ExBitstamp.SymbolTest do
  use ExUnit.Case, async: true
  doctest ExBitstamp.Symbol

  test "downcase converts an atom to a downcased string" do
    assert ExBitstamp.Symbol.downcase(:FOO) == "foo"
  end

  test "downcase converts uppercase strings to downcase" do
    assert ExBitstamp.Symbol.downcase("FOO") == "foo"
  end
end
