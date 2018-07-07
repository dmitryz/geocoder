require 'rails_helper'
require 'geocoder/resolver'

describe Geocoder::Resolver do
  let(:service) { described_class.new(adapter: google_adapter) }
  let(:google_adapter) { instance_double(Geocoder::Adapters::Google) }
  before do
    allow(google_adapter).to receive(:geocode_address).and_return(OpenStruct.new(longtitude: 1, latitude: 2))
  end

  describe "when Geocoder was called" do
    subject! { service.call("Checkpoint charly") }

    it "returns geoposition" do
      is_expected.to be_a_kind_of OpenStruct
    end
  end
end
