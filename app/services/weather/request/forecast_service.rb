# frozen_string_literal: true

module Weather
  module Request
    class ForecastService < BaseService
      def initialize(lat: nil, lng: nil, units: 'metric')
        @lat = lat
        @lng = lng
        @units = units
      end

      private

      def path
        '/data/2.5/forecast'
      end

      def params
        {
          lat: @lat,
          lon: @lng,
          units: @units
        }
      end
    end
  end
end
