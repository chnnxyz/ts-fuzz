defmodule TsfuzzTest do
  use ExUnit.Case
  doctest Tsfuzz

  test "greets the world" do
    assert Tsfuzz.hello() == :world
  end
end
