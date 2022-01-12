# frozen_string_literal: true

module Ahoy
  class Store < Ahoy::DatabaseStore
    def authenticate(_data); end
  end
end

Ahoy.mask_ips = true
Ahoy.cookies = false

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false
