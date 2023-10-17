# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenWeather::Forecast do
  describe 'having one item in weather' do
    subject do
      described_class.new(
        date_time: DateTime.now.beginning_of_day,
        temp: 20.0,
        feels_like: 19.0,
        weather: ['Rain'],
        humidity: 70,
        wind_speed: 9
      )
    end

    it 'returns a string when calling weather_text' do
      expect(subject.weather_text).to eq('Rain')
    end

    it 'returns true for weather_array?' do
      expect(subject.send(:weather_array?)).to be(true)
    end
  end

  describe 'having two items in weather' do
    subject do
      described_class.new(
        date_time: DateTime.now.beginning_of_day,
        temp: 20.0,
        feels_like: 19.0,
        weather: %w[Rain Snow],
        humidity: 70,
        wind_speed: 9
      )
    end

    it 'returns a string when calling weather_text' do
      expect(subject.weather_text).to eq('Rain, Snow')
    end

    it 'returns true for weather_array?' do
      expect(subject.send(:weather_array?)).to be(true)
    end
  end

  describe 'having nil in weather' do
    subject do
      described_class.new(
        date_time: DateTime.now.beginning_of_day,
        temp: 20.0,
        feels_like: 19.0,
        weather: nil,
        humidity: 70,
        wind_speed: 9
      )
    end

    it 'returns a nil when calling weather_text' do
      expect(subject.weather_text).to be_nil
    end

    it 'returns false for weather_array?' do
      expect(subject.send(:weather_array?)).to be(false)
    end
  end

  describe 'having a string in weather' do
    subject do
      described_class.new(
        date_time: DateTime.now.beginning_of_day,
        temp: 20.0,
        feels_like: 19.0,
        weather: 'Blah',
        humidity: 70,
        wind_speed: 9
      )
    end

    it 'returns a blah when calling weather_text' do
      expect(subject.weather_text).to eq('Blah')
    end

    it 'returns false for weather_array?' do
      expect(subject.send(:weather_array?)).to be(false)
    end
  end
end
