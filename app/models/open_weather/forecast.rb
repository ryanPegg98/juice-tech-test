# frozen_string_literal: true

module OpenWeather
  class Forecast
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :date_time
    attribute :temp
    attribute :feels_like
    attribute :weather
    attribute :humidity
    attribute :wind_speed

    def weather_text
      weather_array? ? weather.join(', ') : weather
    end

    private

    def weather_array?
      weather.present? && weather.is_a?(Array)
    end
  end
end
