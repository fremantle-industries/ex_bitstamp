defmodule ExBitstamp.Private do
  alias ExBitstamp.Api

  def balance do
    "balance/"
    |> Api.post
  end

  def buy_limit(symbol, price, amount) do
    "buy/#{symbol}/"
    |> Api.post(%{"price" => price, "amount" => amount})
    |> case do
      {:ok, %{"status" => "error", "reason" => reason}} ->
        {:error, reason}
      {:ok, order} ->
        {:ok, order}
    end
  end
end
