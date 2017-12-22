defmodule ExBitstamp do
  @moduledoc """
  Bitstamp API client for Elixir.
  """

  defdelegate order_book(symbol), to: ExBitstamp.Public
end
