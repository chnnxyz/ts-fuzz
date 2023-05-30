defmodule Tsfuzz.Fuzzy.Membership do

  def gaussian(x, c \\ 0, s \\ 1) when s != 0 do
    x = Nx.tensor(x)

    phi = x
      |> Nx.add(-c)
      |> Nx.divide(s)
      |> Nx.pow(2)
      |> Nx.divide(-2)
      |> Nx.exp()

    phi
  end

  def gaussian(_x, _c, s), do: raise(ArgumentError, "Standard deviation cannot be #{s}")
end
