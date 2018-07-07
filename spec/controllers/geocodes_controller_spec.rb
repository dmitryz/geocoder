require 'rails_helper'

describe GeocodesController do
  before do
    Geocoder::Adapters::Google.url = "https://maps.googleapis.com/maps/api/geocode/json"
    Geocoder::Adapters::Google.key = "BLABLAKEY"
  end

  after do
    Geocoder::Adapters::Google.url = nil
    Geocoder::Adapters::Google.key = nil
  end

  describe "Unauthorized request" do
    it "should get forbidden error" do
      get :search, params: { query: 'Checkpoint charly' }
      expect(response.response_code).to eq(401)
    end
  end

  describe "Authorized request" do
    let!(:user) { FactoryBot.create(:user) }
    before(:each) do
      request.headers.merge! user.create_new_auth_token
    end

    describe "with successfull response from geocoder adapter" do
      before do
        allow_any_instance_of(Geocoder::Resolver).to receive(:call).and_return(OpenStruct.new(longtitude: 1, latitude: 2))
      end

      it "should calculate geocode" do
        process :search, method: :get, params: { query: 'Checkpoint charly' }
        expect(response.response_code).to eq(200)
        expect(response.body).to eq({longtitude: 1, latitude: 2}.to_json)
      end
    end

    describe "with error response from geocoder adapter" do
      let(:geocode_denied) { JSON.parse(File.read('spec/fixtures/geocoder/google_denied.json')) }
      before do
        stub_request(:get, //)
          .to_return(
            status: 200,
            body: geocode_denied.to_json
          )
      end

      it "should return error" do
        process :search, method: :get, params: { query: 'Checkpoint charly' }
        expect(response.response_code).to eq(422)
        expect(response.body).to eq({error: "REQUEST_DENIED"}.to_json)
      end
    end

    describe "with wrong response from geocoder adapter" do
      before do
        stub_request(:get, //)
          .to_return(
            status: 200,
            body: {}.to_json
          )
      end

      it "should return error" do
        process :search, method: :get, params: { query: 'Checkpoint charly' }
        expect(response.response_code).to eq(422)
        expect(response.body).to eq({error: "Invalid answer"}.to_json)
      end
    end

    describe "with timeout response from geocoder adapter" do
      before do
        stub_request(:get, //)
          .to_raise(Faraday::Error::ConnectionFailed)
      end

      it "should return error" do
        process :search, method: :get, params: { query: 'Checkpoint charly' }
        expect(response.response_code).to eq(502)
        expect(response.body).to eq({error: "Connection failed"}.to_json)
      end
    end

  end
end
