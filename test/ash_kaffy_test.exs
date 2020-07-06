defmodule AshKaffyTest do
  use ExUnit.Case
  doctest AshKaffy

  test "greets the world" do
    assert AshKaffy.hello() == :world
  end
end
