defmodule ExBitstamp.Api do
  @moduledoc """
  Manage HTTP requests to the Bitstamp REST API
  """

  def get(path) do
    path
    |> build_url
    |> HTTPoison.get([])
    |> parse_response
  end

  def post(path, params \\ %{}) do
    headers = %{"Content-Type": "application/x-www-form-urlencoded"}
    nonce = generate_nonce()
    message = [nonce, customer_id(), api_key()]
              |> Enum.join("")
    body = params
           |> Map.merge(%{"key": api_key(), "signature": sign(message), "nonce": nonce})
           |> URI.encode_query

    path
    |> build_url
    |> HTTPoison.post(body, headers)
    |> parse_response
  end

  defp generate_nonce do
    :os.system_time
  end

  defp customer_id do
    Application.get_env(:ex_bitstamp, :customer_id)
  end

  defp api_key do
    Application.get_env(:ex_bitstamp, :api_key)
  end

  defp sign(message) do
    :sha256
    |> :crypto.hmac(Application.get_env(:ex_bitstamp, :api_secret), message)
    |> Base.encode16
  end

  defp build_url(path) do
    "https://www.bitstamp.net/api/v2/#{path}"
  end

  defp parse_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        handle_ok(response_body)
      {:ok, %HTTPoison.Response{status_code: 403, body: response_body}} ->
        handle_forbidden(response_body)
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

  defp handle_forbidden(response_body) do
    response_body
    |> JSON.decode
    |> case do
      {:ok, %{"status" => "error", "reason" => reason, "code" => code}} ->
        {:error, "#{reason} code: #{code}"}
    end
  end
end
