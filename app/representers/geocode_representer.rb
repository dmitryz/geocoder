class GeocodeRepresenter < Roar::Decorator
  include Representable::JSON

  property :longtitude
  property :latitude
end
