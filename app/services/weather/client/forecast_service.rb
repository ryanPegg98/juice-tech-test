# frozen_string_literal: true

module Weather
  module Client
    class ForecastService < BaseService
      def self.find(lat, lng)
        new(lat, lng).find
      end

      def initialize(lat, lng)
        @lat = lat
        @lng = lng
      end

      def find
        if successful_fetch?
          list = fetch_data.dig(:response, 'list')

          {}.tap do |days|
            list.each do |data|
              datetime = Time.zone.at(data['dt']).to_datetime
              key = datetime.strftime('%Y%m%d')
              days[key] ||= { date: datetime.beginning_of_day, data: [] }

              days[key][:data] << OpenWeather::Forecast.new(
                date_time: datetime,
                temp: data.dig('main', 'temp'),
                feels_like: data.dig('main', 'feels_like'),
                weather: data['weather']&.map { |weather| weather['description'].capitalize },
                humidity: data.dig('main', 'humidity'),
                wind_speed: data.dig('wind', 'speed')
              )
            end
          end.map do |key, value|
            OpenWeather::ForecastDay.new(
              date: value[:date],
              key:,
              forecasts: value[:data]
            )
          end
        else
          {}
        end
      end

      private

      def request_service
        @request_service ||= Weather::Request::ForecastService.new(lat: @lat, lng: @lng)
      end
    end
  end
end
