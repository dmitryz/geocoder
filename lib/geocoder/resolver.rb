require 'geocoder/adapters/google'

module Geocoder
  class Resolver
    def initialize(adapter: Geocoder::Adapters::Google.new)
      @adapter = adapter
    end

    def call(query)
      adapter.geocode_address(query)
    end

  private
    attr_reader :adapter
  end
end
