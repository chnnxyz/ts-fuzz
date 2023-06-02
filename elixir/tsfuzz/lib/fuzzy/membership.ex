defmodule Tsfuzz.Fuzzy.Membership do


  @doc """
  Gaussian membership function
  """
  @spec gaussian([...], float(), float()) :: Nx.tensor()
  def gaussian(x, c \\ 0, s \\ 1)
  def gaussian(x, c, s) when s != 0 do
    x |> Nx.tensor()
      |> Nx.add(-c)
      |> Nx.divide(s)
      |> Nx.pow(2)
      |> Nx.divide(-2)
      |> Nx.exp()
  end

  def gaussian(_x, _c, s), do: raise(ArgumentError, "Standard deviation cannot be #{s}")
end
