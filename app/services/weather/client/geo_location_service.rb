# frozen_string_literal: true

module Weather
  module Client
    class GeoLocationService < BaseService
      def self.search(query)
        new(query).search
      end

      def initialize(query)
        @query = query
      end

      def search
        if successful_fetch?
          fetch_data[:response].map do |country|
            OpenWeather::Location.new(
              lat: country['lat'],
              lng: country['lon'],
              name: country['name'],
              country: country['country']
            )
          end
        else
          []
        end
      end

      private

      def request_service
        @request_service ||= Weather::Request::GeoLocationService.new(query: @query)
      end
    end
  end
end
