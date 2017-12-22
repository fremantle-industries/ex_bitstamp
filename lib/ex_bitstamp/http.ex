defmodule ExBitstamp.Http do
  @moduledoc """
  Manage http requests to Bitstamp REST API
  """

  def get(path) do
    headers = []

    path
    |> build_url
    |> HTTPoison.get(headers)
    |> case do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        handle_ok(response_body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        handle_not_found()
      {:error, error} ->
        {:error, error}
    end
  end

  defp handle_ok(response_body) do
    response_body
    |> JSON.decode
    |> case do
      {:ok, body} -> {:ok, body}
      {:error, error} -> {:error, error}
    end
  end

  defp handle_not_found do
    {:error, "not found"}
  end

  defp build_url(path) do
    "https://www.bitstamp.net/api/v2/#{path}"
  end
end
