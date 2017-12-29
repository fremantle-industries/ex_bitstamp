defmodule ExBitstamp do
  @moduledoc """
  Bitstamp API client for Elixir.
  """

  defdelegate order_book(symbol), to: ExBitstamp.Public
  defdelegate ticker(symbol), to: ExBitstamp.Public
  defdelegate balance, to: ExBitstamp.Private
  defdelegate buy_limit(symbol, price, amount), to: ExBitstamp.Private
  defdelegate sell_limit(symbol, price, amount), to: ExBitstamp.Private
  defdelegate order_status(order_id), to: ExBitstamp.Private
end
