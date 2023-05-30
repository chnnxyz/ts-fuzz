defmodule Tsfuzz.Banfis.Bayesian do
  alias :math, as: Math

  def likelihood(y, yhat, s \\ 1) do
    y = y
    yhat = Nx.tensor(yhat)

    l = yhat
      |> Nx.subtract(y)
      |> Nx.divide(s)
      |> Nx.pow(2)
      |> Nx.divide(-2)
      |> Nx.exp()
      |> Nx.divide(Math.sqrt(2 * Math.pi * Math.pow(s, 2)))

    l
  end

  def likelihood_scalar(y, yhat, s \\ 1) do
    l = (y - yhat) / s
      |> Math.pow(2)
      |> Kernel./(-2)
      |> Math.exp()
      |> Kernel./(Math.sqrt(2 * Math.pi * Math.pow(s, 2)))

    l
  end

  def uniform_priors(w) do
    Nx.broadcast(Nx.tensor(1 / w), {w})
  end

  def posteriors(likelihoods, priors) do
    likelihoods = Nx.tensor(likelihoods)
    priors = Nx.tensor(priors)

    upper = Nx.multiply(likelihoods, priors)
    Nx.divide(upper, Nx.sum(upper))
  end

  def update_priors(priors, posteriors, a \\ 0.9) do
    priors = Nx.tensor(priors)
    posteriors = Nx.tensor(posteriors)

    out = Nx.add(Nx.multiply(priors, a), Nx.multiply(posteriors,(1-a)))
    out
  end
end
