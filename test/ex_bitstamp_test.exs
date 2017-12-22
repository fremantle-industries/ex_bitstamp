defmodule ExBitstampTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExBitstamp

  setup_all do
    HTTPoison.start
    ExVCR.Config.cassette_library_dir("test/fixture/vcr_cassettes")
  end

  test "order_book returns a list of bids & asks for the currency pair" do
    use_cassette "order_book_success" do
      {:ok, order_book} = ExBitstamp.order_book(:btcusd)

      assert order_book == %{
        "timestamp" => "1513896396",
        "bids" => [
          ["15677.95", "0.15180556"],
          ["15677.94", "1.49272243"],
          ["15677.75", "0.27232000"],
          ["15677.74", "12.52500000"],
          ["15672.29", "0.00319470"]
        ],
        "asks" => [
          ["15730.00", "0.27969236"],
          ["15734.78", "0.26145000"],
          ["15734.80", "0.95060000"],
          ["15735.00", "1.70000000"],
          ["15739.95", "0.00251380"]
        ]
      }
    end
  end

  test "order_book supports strings and downcases the given symbol" do
    use_cassette "order_book_success" do
      {:ok, order_book} = ExBitstamp.order_book("BTCUSD")

      assert order_book == %{
        "timestamp" => "1513896396",
        "bids" => [
          ["15677.95", "0.15180556"],
          ["15677.94", "1.49272243"],
          ["15677.75", "0.27232000"],
          ["15677.74", "12.52500000"],
          ["15672.29", "0.00319470"]
        ],
        "asks" => [
          ["15730.00", "0.27969236"],
          ["15734.78", "0.26145000"],
          ["15734.80", "0.95060000"],
          ["15735.00", "1.70000000"],
          ["15739.95", "0.00251380"]
        ]
      }
    end
  end

  test "order_book returns an error/message tuple when the symbol does not exist" do
    use_cassette "order_book_error" do
      assert ExBitstamp.order_book(:IDONTEXIST) == {:error, "not found"}
    end
  end
end
