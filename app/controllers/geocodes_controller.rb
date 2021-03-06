class GeocodesController < ApplicationController
  before_action :authenticate_user!
  require 'geocoder/resolver'

  def search
    geocoder = Geocoder::Resolver.new(adapter: GeocoderConfig.new.adapter)
    result = geocoder.call(params[:query])
    render json: GeocodeRepresenter.new(result).to_json
  end
end
