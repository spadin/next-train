require "spec_helper"
require "next_train"

describe NextTrain do
  let(:api_key) { 'test-api-key' }
  let(:stpid) { 30092 }
  let(:base_time) { "20150201 21:00:00" }
  let(:two_minutes_from_base_time) { "20150201 21:02:00" }

  it "returns 2 minutes when train is two minutes away" do
    stub_cta_train_request(
      api_key: api_key,
      stpid: stpid,
      response: arrival_response(two_minutes_from_base_time)
    )

    with_time(base_time) do
      described_class.api_key = api_key
      expect(described_class[stpid]).to eq("2 minutes")
    end
  end

  it "returns arriving when train is 0 minutes away" do
    stub_cta_train_request(
      api_key: api_key,
      stpid: stpid,
      response: arrival_response(base_time)
    )

    with_time(base_time) do
      described_class.api_key = api_key
      expect(described_class[stpid]).to eq("arriving")
    end
  end

  it "returns invalid api_key message when api_key is nil" do
    stub_cta_train_request(
      api_key: nil,
      stpid: stpid,
      response: error_response
    )

    with_time(base_time) do
      described_class.api_key = nil
      expect { described_class[stpid]}.to raise_error("No data returned, please check your API key")
    end
  end

  it "supresses output from CTA::TrainTracker gem" do
    stub_cta_train_request(
      api_key: nil,
      stpid: stpid,
      response: error_response
    )

    with_time(base_time) do
      described_class.api_key = nil

      out = capture_output do
        expect { described_class[stpid]}.to raise_error
      end

      expect(out.string).to be_blank
    end
  end
end
