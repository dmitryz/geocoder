require 'rails_helper'
require 'geocoder/adapters/google'

describe Geocoder::Adapters::Google do
  describe "default settings" do
    subject { described_class.default_settings }

    context "when its missing" do
      its(:url) { is_expected.to be_blank }
      its(:key) { is_expected.to be_blank }
    end

    context "when its given" do
      before do
        described_class.url = "https://maps.googleapis.com/maps/api/geocode/json"
        described_class.key = "BLABLAKEY"
      end

      its(:url) { is_expected.to eq "https://maps.googleapis.com/maps/api/geocode/json" }
      its(:key) { is_expected.to eq "BLABLAKEY" }
    end
  end

  describe "#geocode_address" do
    subject { described_class.new(settings).geocode_address(query) }

    let(:settings) do
      OpenStruct.new(
        url: "https://maps.googleapis.com/maps/api/geocode/json",
        key: "BLABLAKEY"
      )
    end

    let(:query) { "Checkoint charly" }
    let(:geocode_answer_ok) { JSON.parse(File.read('spec/fixtures/geocoder/google_checkpoint_charly.json')) }
    let(:request_url) { settings.url + "?address=#{query}&key=BLABLAKEY" }

    context "when geocode is successfull" do
      before do
        stub_request(:get, request_url)
          .with(
            headers: {
              "Content-Type" => "application/json"
          })
          .to_return(
            status: 200,
            body: geocode_answer_ok.to_json
          )
      end

      it { is_expected.to eq(OpenStruct.new(longtitude: -122.0842499, latitude: 37.4224764)) }
    end

    context "when not` found" do
      before do
        stub_request(:get, request_url)
          .to_return(status: [404, "Not Found"])
      end

      it { expect { subject }.to raise_error(Geocoder::Error, "404: Not Found") }
    end

    context "when not authenticated" do
      let(:geocode_denied) { JSON.parse(File.read('spec/fixtures/geocoder/google_denied.json')) }
      before do
        stub_request(:get, request_url)
          .to_return(
            status: 200,
            body: geocode_denied.to_json
          )
      end

      it { expect { subject }.to raise_error(Geocoder::Error, "REQUEST_DENIED") }
    end
  end
end

