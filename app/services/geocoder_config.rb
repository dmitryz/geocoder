class GeocoderConfig
  def initialize(adapter_label: :google)
    @adapter_label = adapter_label
  end

  def adapter
    case @adapter_label
    when :google
      Geocoder::Adapters::Google.new
    else
      raise StandardError.new("Not found adapter")
    end
  end
end
