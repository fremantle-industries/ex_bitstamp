defmodule ExBitstamp.Public do
  alias ExBitstamp.Http
  alias ExBitstamp.Symbol

  @doc """
  Return a list of open orders for a currency pair.

  ## Examples

      iex> ExBitstamp.order_book(:btcusd)
      {:ok, %{"timestamp" => 101, "bids" => [], "asks" => []}}

  """
  def order_book(symbol) do
    "order_book/#{Symbol.downcase(symbol)}"
    |> Http.get
  end
end
