defmodule Tsfuzz.Banfis.Bayesian do
  alias :math, as: Math

  @doc """
  Calculates likelihood for array-like values and predictions
  """
  def likelihood(y, yhat, s \\ 1) do
    y = y
    yhat = Nx.tensor(yhat)

    yhat
      |> Nx.subtract(y)
      |> Nx.divide(s)
      |> Nx.pow(2)
      |> Nx.divide(-2)
      |> Nx.exp()
      |> Nx.divide(Math.sqrt(2 * Math.pi * Math.pow(s, 2)))

  end

  @doc """
  Calculates likelihood for a single observation
  """
  def likelihood_scalar(y, yhat, s \\ 1) do
    (y - yhat) / s
      |> Math.pow(2)
      |> Kernel./(-2)
      |> Math.exp()
      |> Kernel./(Math.sqrt(2 * Math.pi * Math.pow(s, 2)))

  end

  @doc """
  Generates a set of uniform priors of size w
  """
  @spec uniform_priors(integer()) :: Nx.tensor()
  def uniform_priors(w) do
    Nx.broadcast(Nx.tensor(1 / w), {w})
  end

  @doc """
  Creates posteriors based on likelihoods and priors
  """
  def posteriors(likelihoods, priors) do
    likelihoods = Nx.tensor(likelihoods)
    priors = Nx.tensor(priors)

    upper = Nx.multiply(likelihoods, priors)
    Nx.divide(upper, Nx.sum(upper))
  end

  @doc """
  Updates prior probabilities to new priors using a list of priors,
  a list of posteriors and a regularization factor
  """
  def update_priors(priors, posteriors, a \\ 0.9) do
    priors = Nx.tensor(priors)
    posteriors = Nx.tensor(posteriors)

    out = Nx.add(Nx.multiply(priors, a), Nx.multiply(posteriors,(1-a)))
    out
  end

  @doc """
  Gets the average probability
  """
  @spec average_probability([...]) :: Nx.tensor()
  def average_probability(probs) do
    probs = Nx.tensor(probs)
    cond do
      tuple_size(probs.shape) == 1 ->
        Nx.mean(probs)
      tuple_size(probs.shape) == 2 ->
        Nx.mean(probs, axes: [1])
      true ->
        raise(ArgumentError, "Only vectors and matrices can be processed. Dimensions are #{tuple_size(probs.shape)}")
    end
  end

end
