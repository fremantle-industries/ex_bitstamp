defmodule ExBitstamp.Public do
  alias ExBitstamp.Api
  alias ExBitstamp.Symbol

  @doc """
  Return a list of open orders for a currency pair.

  ## Examples

      iex> ExBitstamp.order_book(:btcusd)
      {:ok, %{"timestamp" => "1514422945", "bids" => [], "asks" => []}}

  """
  def order_book(symbol) do
    "order_book/#{Symbol.downcase(symbol)}"
    |> Api.get
  end

  @doc """
  Returns data for the currency pair.

  ## Examples

      iex> ExBitstamp.ticker(:btcusd)
      {:ok, %{"ask" => "15206.12", "bid" => "15200.04", "high" => "16480.52", "last" => "15200.00", "low" => "14484.00", "open" => "15390.05", "timestamp" => "1514422945", "volume" => "15637.34379848", "vwap" => "15448.06"}}

  """
  def ticker(symbol) do
    "ticker/#{Symbol.downcase(symbol)}"
    |> Api.get
  end
end
