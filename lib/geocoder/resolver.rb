require 'geocoder/adapters/google'

module Geocoder
  class Resolver
    def initialize(adapter: Geocoder::Adapters::Google.new, cache: nil)
      @adapter = adapter
      @cache = cache
    end

    def call(query)
      result = cache&.get(query)
      return result if result

      result = adapter.geocode_address(query)
      cache&.store(query, result)
      result
    end

  private
    attr_reader :adapter
    attr_reader :cache
  end
end
