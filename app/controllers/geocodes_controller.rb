class GeocodesController < ApplicationController
  before_action :authenticate_user!
  require 'geocoder/resolver'

  def search
    geocoder = Geocoder::Resolver.new
    result = geocoder.call(params[:query])
    render json: GeocodeRepresenter.new(result).to_json
  end
end
