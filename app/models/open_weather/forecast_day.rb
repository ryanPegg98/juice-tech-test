# frozen_string_literal: true

module OpenWeather
  class ForecastDay
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :date
    attribute :key
    attribute :forecasts

    %w[temp feels_like humidity wind_speed].each do |field|
      define_method "average_#{field}".to_sym do
        values = forecasts.map { |forecast| forecast.send(field.to_sym).to_f }
        values.sum / values.size
      end
    end

    def date_text
      date.strftime('%d/%m/%Y')
    end
  end
end
