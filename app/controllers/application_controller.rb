class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  respond_to :json

  rescue_from ActiveRecord::RecordNotFound do |error|
    message = "#{error.model} is not found"
    render json: { error: message }, status: :not_found
  end

  rescue_from Geocoder::Error do |error|
    render json: { error: error }, status: :unprocessable_entity
  end

  rescue_from Geocoder::ConnectionError do |error|
    render json: { error: error }, status: :bad_gateway
  end
end
