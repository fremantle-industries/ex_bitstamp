defmodule ExBitstamp.Private do
  alias ExBitstamp.Api

  def balance do
    "balance/"
    |> Api.post
  end

  def buy_limit(symbol, price, amount) do
    "buy/#{symbol}/"
    |> Api.post(%{"price" => price, "amount" => amount})
    |> handle_create_order
  end

  def sell_limit(symbol, price, amount) do
    "sell/#{symbol}/"
    |> Api.post(%{"price" => price, "amount" => amount})
    |> handle_create_order
  end

  def order_status(order_id) do
    "order_status/"
    |> Api.post(%{"id" => order_id})
    |> case do
      {:ok, %{"status" => "error", "reason" => reason}} ->
        {:error, reason}
      {:ok, details} ->
        {:ok, details}
    end
  end

  def cancel_order(order_id) do
    "cancel_order/"
    |> Api.post(%{"id" => order_id})
    |> case do
      {:ok, %{"error" => reason}} ->
        {:error, reason}
      {:ok, details} ->
        {:ok, details}
    end
  end

  defp handle_create_order({:ok, %{"status" => "error", "reason" => reason}}) do
    {:error, reason}
  end
  defp handle_create_order({:ok, order}) do
    {:ok, order}
  end
end
