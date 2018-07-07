require 'rails_helper'

describe GeocodesController do
  before do
    allow_any_instance_of(Geocoder::Resolver).to receive(:call).and_return(OpenStruct.new(longtitude: 1, latitude: 2))
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

    it "should calculate geocode" do
      process :search, method: :get, params: { query: 'Checkoint charly' }
      expect(response.response_code).to eq(200)
      expect(response.body).to eq({longtitude: 1, latitude: 2}.to_json)
    end
  end
end
