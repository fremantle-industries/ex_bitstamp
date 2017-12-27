defmodule ExBitstamp.Private do
  alias ExBitstamp.Api

  def balance do
    "balance/"
    |> Api.post
  end
end
