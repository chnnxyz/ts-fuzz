defmodule Tsfuzz.Fuzzy.Logic.And do
  @moduledoc """
  Module containing T-norm functions for using as fuzzy and
  """
  def and_min(a, b), do: min(a,b)

  def and_prod(a, b), do: a * b

  def and_lukasiewicz(a, b), do: max(0, a + b - 1)

  def and_drastic(a, b) do
    t = fn _ ->
      cond do
        a == 1 ->
          1
        b == 1 ->
          1
        true ->
          0
      end
    end

    t
  end

  def and_nilpotent_min(a, b) do
    t = fn _ ->
      cond do
        a + b > 1 ->
          min(a, b)
        true ->
          0
      end
    end

    t
  end

  def and_hamacher(a, b) do
    t = fn _ ->
      cond do
        a == b and a == 0 ->
          0

        true ->
          a * b / (a + b - a * b)
      end
    end

    t
  end

end

defmodule Tsfuzz.Fuzzy.Logic.Or do
  @moduledoc """
  Module containing T-conorm functions to use as fuzzy or
  """
  def or_max(a, b), do: max(a, b)

  def or_probsum(a, b), do: a + b - (a * b)

  def or_lukasiewicz(a, b), do: min(a + b, 1)

  def or_drastic(a, b) do
    t = fn _ ->
      cond do
        a == 0 ->
          0
        b == 0 ->
          0
        true ->
          1
      end
    end

    t
  end

  def or_nilpotent(a, b) do
    t = fn _ ->
      cond do
        a + b < 1 ->
          max(a, b)
        true ->
          1
      end
    end

    t
  end

  def or_hamacher(a, b), do: (a + b) / (1 + a * b)

end
