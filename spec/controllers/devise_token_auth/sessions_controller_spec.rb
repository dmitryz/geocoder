require 'rails_helper'

describe DeviseTokenAuth::SessionsController do
  http_status_200_ok = 200

  it "should login" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryBot.create(:user)
    post :create, params: { email: user.email, password: "testtest", format: :json }
    expect(response.response_code).to eq(http_status_200_ok)
  end
end
