require 'geocoder/resolver'
Geocoder::Adapters::Google.url = ENV['GEOCODER_GOOGLE_URL']
Geocoder::Adapters::Google.key = ENV['GEOCODER_GOOGLE_KEY']
