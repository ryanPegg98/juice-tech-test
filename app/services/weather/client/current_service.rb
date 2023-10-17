# frozen_string_literal: true

module Weather
  module Client
    class CurrentService < BaseService
      def self.find(lat, lng)
        new(lat, lng).find
      end

      def initialize(lat, lng)
        @lat = lat
        @lng = lng
      end

      def find
        return unless successful_fetch?

        data = fetch_data[:response]

        OpenWeather::Forecast.new(
          temp: data.dig('main', 'temp'),
          feels_like: data.dig('main', 'feels_like'),
          weather: data['weather']&.map { |weather| weather['description'].capitalize },
          humidity: data.dig('main', 'humidity'),
          wind_speed: data.dig('wind', 'speed')
        )
      end

      private

      def request_service
        @request_service ||= Weather::Request::CurrentService.new(lat: @lat, lng: @lng)
      end
    end
  end
end
