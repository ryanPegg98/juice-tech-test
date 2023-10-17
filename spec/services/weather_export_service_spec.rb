# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherExportService, type: :model do
  let!(:name) { 'London' }
  let!(:days) do
    [
      OpenWeather::ForecastDay.new(
        date: Time.zone.today,
        forecasts: [
          OpenWeather::Forecast.new(
            date_time: DateTime.now.beginning_of_day,
            temp: 20.0,
            feels_like: 19.0,
            humidity: 90,
            wind_speed: 10
          ),
          OpenWeather::Forecast.new(
            date_time: DateTime.now.end_of_day,
            temp: 15.0,
            feels_like: 14.0,
            humidity: 80,
            wind_speed: 5
          )
        ]
      ),
      OpenWeather::ForecastDay.new(
        date: Time.zone.today + 1.day,
        forecasts: [
          OpenWeather::Forecast.new(
            date_time: DateTime.now.beginning_of_day + 1.day,
            temp: 21.0,
            feels_like: 18.0,
            humidity: 80,
            wind_speed: 11
          ),
          OpenWeather::Forecast.new(
            date_time: DateTime.now.end_of_day + 1.day,
            temp: 13.0,
            feels_like: 12.0,
            humidity: 85,
            wind_speed: 1
          )
        ]
      )
    ]
  end

  describe 'basic methods' do
    subject { described_class.new(name, days) }

    it 'returns the filename' do
      expect(subject.filename).to eq('london_forecast_export.csv')
    end

    it 'builds the headers' do
      expect(subject.send(:build_headers)).to eq([
                                                   '0000 - feels_like',
                                                   '0000 - humidity',
                                                   '0000 - temp',
                                                   '0000 - wind_speed',
                                                   '2359 - feels_like',
                                                   '2359 - humidity',
                                                   '2359 - temp',
                                                   '2359 - wind_speed'
                                                 ])
    end

    it 'joins the built headers and default headers' do
      expect(subject.send(:headers)).to eq([
                                             'Date',
                                             'Location',
                                             '0000 - feels_like',
                                             '0000 - humidity',
                                             '0000 - temp',
                                             '0000 - wind_speed',
                                             '2359 - feels_like',
                                             '2359 - humidity',
                                             '2359 - temp',
                                             '2359 - wind_speed'
                                           ])
    end

    it 'builds the data' do
      expect(subject.send(:build_data)).to eq([
                                                {
                                                  date: Time.zone.today,
                                                  location: name,
                                                  '0000_temp': 20.0,
                                                  '0000_feels_like': 19.0,
                                                  '0000_humidity': 90,
                                                  '0000_wind_speed': 10,
                                                  '2359_temp': 15,
                                                  '2359_feels_like': 14,
                                                  '2359_humidity': 80,
                                                  '2359_wind_speed': 5
                                                }, {
                                                  date: Time.zone.today + 1.day,
                                                  location: name,
                                                  '0000_temp': 21.0,
                                                  '0000_feels_like': 18.0,
                                                  '0000_humidity': 80,
                                                  '0000_wind_speed': 11,
                                                  '2359_temp': 13,
                                                  '2359_feels_like': 12,
                                                  '2359_humidity': 85,
                                                  '2359_wind_speed': 1
                                                }
                                              ])
    end

    it 'returns the data as a string for data_to_csv' do
      expect(subject.send(:data_to_csv)).to eq([
        [Time.zone.today, name, 19.0, 90, 20.0, 10, 14.0, 80, 15.0, 5].join(','),
        [Time.zone.today + 1.day, name, 18.0, 80, 21.0, 11, 12.0, 85, 13.0, 1].join(',')
      ].join("\n"))
    end

    it 'returns the headers and data combined for export' do
      expect(subject.export).to eq([
        ['Date', 'Location', '0000 - feels_like', '0000 - humidity', '0000 - temp', '0000 - wind_speed', '2359 - feels_like',
         '2359 - humidity', '2359 - temp', '2359 - wind_speed'].join(','),
        [Time.zone.today, name, 19.0, 90, 20.0, 10, 14.0, 80, 15.0, 5].join(','),
        [Time.zone.today + 1.day, name, 18.0, 80, 21.0, 11, 12.0, 85, 13.0, 1].join(',')
      ].join("\n"))
    end
  end
end
