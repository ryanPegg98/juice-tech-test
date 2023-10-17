require 'rails_helper'

RSpec.describe OpenWeather::ForecastDay, type: :model do
  let!(:morning_forecast) do 
    OpenWeather::Forecast.new(
      date_time: DateTime.now.beginning_of_day,
      temp: 20.0 ,
      feels_like: 19.0,
      weather: ['Rain'],
      humidity: 70,
      wind_speed: 9,
    )
  end
  let!(:evening_forecast) do 
    OpenWeather::Forecast.new(
      date_time: DateTime.now.end_of_day,
      temp: 10.0 ,
      feels_like: 9.0,
      weather: ['Rain'],
      humidity: 80,
      wind_speed: 10,
    )
  end

  describe "when calculating averanges" do
    subject { OpenWeather::ForecastDay.new(date: Date.today, forecasts: [morning_forecast, evening_forecast]) }

    it "should calculate the average of the temp" do
      expect(subject.average_temp).to eq(15.0)
    end

    it "should calculate the average of the feels_like" do
      expect(subject.average_feels_like).to eq(14.0)
    end

    it "should calculate the average of the humidity" do
      expect(subject.average_humidity).to eq(75.0)
    end

    it "should calculate the average of the wind_speed" do
      expect(subject.average_wind_speed).to eq(9.5)
    end

    it "should return a string for date text" do
      expect(subject.date_text).to eq(Date.today.strftime('%d/%m/%Y'))
    end
  end
end
