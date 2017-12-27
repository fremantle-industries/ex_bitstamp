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

  test "balance returns the value of each account" do
    use_cassette "balance_success" do
      assert ExBitstamp.balance == {:ok, %{
        "xrp_reserved" => "0.00000000",
        "bcheur_fee" => "0.00",
        "ltc_balance" => "0.00000000",
        "ltcbtc_fee" => "0.20",
        "btc_balance" => "0.00000000",
        "ltc_reserved" => "0.00000000",
        "eth_balance" => "0.00000000",
        "eur_available" => "0.00",
        "xrpbtc_fee" => "0.20",
        "bchusd_fee" => "0.00",
        "bch_available" => "0.00000000",
        "eurusd_fee" => "0.20",
        "ethusd_fee" => "0.15",
        "btc_available" => "0.00000000",
        "xrpeur_fee" => "0.20",
        "eur_balance" => "0.00",
        "btceur_fee" => "0.20",
        "usd_balance" => "0.00",
        "bch_balance" => "0.00000000",
        "xrpusd_fee" => "0.20",
        "ltcusd_fee" => "0.20",
        "eth_available" => "0.00000000",
        "bch_reserved" => "0.00000000",
        "ltceur_fee" => "0.20",
        "etheur_fee" => "0.15",
        "eur_reserved" => "0.00",
        "ethbtc_fee" => "0.15",
        "xrp_balance" => "0.00000000",
        "ltc_available" => "0.00000000",
        "bchbtc_fee" => "0.00",
        "eth_reserved" => "0.00000000",
        "btcusd_fee" => "0.20",
        "usd_available" => "0.00",
        "xrp_available" => "0.00000000",
        "usd_reserved" => "0.00",
        "btc_reserved" => "0.00000000"
      }}
    end
  end

  test "balance returns an error/message tuple when the api credentials are invalid" do
    use_cassette "balance_forbidden" do
      assert ExBitstamp.balance == {:error, "Missing key, signature and nonce parameters. code: API0000"}
    end
  end
end
