# frozen_string_literal: true

class WeatherExportService
  DEFAULT_HEADERS = %w[Date Location].freeze
  VALUE_KEYS = %w[temp feels_like humidity wind_speed].freeze

  def self.export(name, data)
    new(name, data).export
  end

  def initialize(name, data)
    @name = name
    @data = data
  end

  def filename
    [
      @name.downcase.gsub(/\s/, '_'),
      '_forecast_export',
      '.csv'
    ].join
  end

  def export
    [
      headers.join(','),
      "\n",
      data_to_csv
    ].join
  end

  private

  def data_to_csv
    build_data.map do |row_data|
      headers.map do |key|
        row_data[key.downcase.gsub(' - ', '_').to_sym]
      end.join(',')
    end.join("\n")
  end

  def build_data
    @data.map do |day|
      {
        date: day.date,
        location: @name
      }.tap do |struct|
        day.forecasts.map do |forecast|
          VALUE_KEYS.each do |value_key|
            key = "#{forecast.date_time.strftime('%H%M')}_#{value_key}".to_sym
            struct[key] = forecast.send(value_key.to_sym)
          end
        end
      end
    end
  end

  def headers
    @headers ||= DEFAULT_HEADERS + build_headers
  end

  def build_headers
    @data.map do |day|
      day.forecasts.map do |hour|
        time_key = hour.date_time.strftime('%H%M')
        VALUE_KEYS.map do |key|
          [time_key, key].join(' - ')
        end
      end
    end.flatten.uniq
  end
end
