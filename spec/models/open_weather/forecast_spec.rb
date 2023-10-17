require 'rails_helper'

RSpec.describe OpenWeather::Forecast, type: :model do
  describe "having one item in weather" do
    subject do
      OpenWeather::Forecast.new(
        date_time: DateTime.now.beginning_of_day,
        temp: 20.0 ,
        feels_like: 19.0,
        weather: ['Rain'],
        humidity: 70,
        wind_speed: 9,
      )
    end

    it "should return a string when calling weather_text" do
      expect(subject.weather_text).to eq('Rain')
    end

    it "should return true for weather_array?" do
      expect(subject.send(:weather_array?)).to be(true)
    end
  end

  describe "having two items in weather" do
    subject do
      OpenWeather::Forecast.new(
        date_time: DateTime.now.beginning_of_day,
        temp: 20.0 ,
        feels_like: 19.0,
        weather: ['Rain', 'Snow'],
        humidity: 70,
        wind_speed: 9,
      )
    end

    it "should return a string when calling weather_text" do
      expect(subject.weather_text).to eq('Rain, Snow')
    end

    it "should return true for weather_array?" do
      expect(subject.send(:weather_array?)).to be(true)
    end
  end

  describe "having nil in weather" do
    subject do
      OpenWeather::Forecast.new(
        date_time: DateTime.now.beginning_of_day,
        temp: 20.0 ,
        feels_like: 19.0,
        weather: nil,
        humidity: 70,
        wind_speed: 9,
      )
    end

    it "should return a nil when calling weather_text" do
      expect(subject.weather_text).to eq(nil)
    end

    it "should return false for weather_array?" do
      expect(subject.send(:weather_array?)).to be(false)
    end
  end

  describe "having a string in weather" do
    subject do
      OpenWeather::Forecast.new(
        date_time: DateTime.now.beginning_of_day,
        temp: 20.0 ,
        feels_like: 19.0,
        weather: "Blah",
        humidity: 70,
        wind_speed: 9,
      )
    end

    it "should return a blah when calling weather_text" do
      expect(subject.weather_text).to eq('Blah')
    end

    it "should return false for weather_array?" do
      expect(subject.send(:weather_array?)).to be(false)
    end
  end
end
