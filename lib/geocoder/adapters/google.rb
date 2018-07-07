require 'geocoder/error'
module Geocoder
  module Adapters
    class Google
      class << self
        attr_accessor :url
        attr_accessor :key

        def default_settings
          OpenStruct.new(
            url: url,
            key: key,
          ).freeze
        end
      end

      def initialize(settings = Google.default_settings)
        @settings = settings
      end

      def geocode_address(query)
        response = send_request('address', query)
        data = validate_result!(response)
        OpenStruct.new(longtitude: data["lng"], latitude: data["lat"])
      end

    private
      def send_request(method, query)
        connection.get do |request|
          request.headers["Content-Type"] = "application/json"
          request.params = build_auth
          request.params[method] = query
        end
      end

      def validate_result!(response)
        raise Error, "#{response.status}: #{response.reason_phrase}" unless response.status == 200

        body = JSON.parse(response.body)

        error = body["status"] != "OK" ? body["status"] : nil
        raise Error, "#{error}" if error.present?

        body["results"][0]["geometry"]["location"]
      end

      def connection
        @connection ||= Faraday.new(url: @settings.url)
      end

      def build_auth
        @auth ||= {
          key: @settings.key
        }
      end
    end
  end
end
