# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Weather::Client::ForecastService, type: :model do
  let!(:lat) { 51.5073219 }
  let!(:lng) { 0.1276474  }
  let!(:success_response) do
    {
      'cod' => '200',
      'message' => 0,
      'cnt' => 40,
      'list' => [
        {
          'dt' => 1_661_871_600,
          'main' => {
            'temp' => 296.76,
            'feels_like' => 296.98,
            'humidity' => 69
          },
          'weather' => [
            {
              'id' => 500,
              'main' => 'Rain',
              'description' => 'light rain',
              'icon' => '10d'
            }
          ],
          wind: {
            'speed' => 0.62
          }
        },
        {
          'dt' => 1_661_882_400,
          'main' => {
            'temp' => 295.45,
            'feels_like' => 295.59,
            'humidity' => 71
          },
          weather: [
            {
              'id' => 500,
              'main' => 'Rain',
              'description' => 'light rain',
              'icon' => '10n'
            }
          ],
          wind: {
            'speed' => 1.97
          }
        }
      ]
    }
  end

  describe 'default methods' do
    subject { described_class.new(lat, lng) }

    let!(:city) { 'London, GB' }

    before do
      stub_request(:get, 'http://api.openweathermap.org/data/2.5/forecast')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil),
            'lat' => lat,
            'lon' => lng,
            'units' => 'metric'
          }
        )
        .to_return(
          status: 200,
          body: Oj.dump(success_response)
        )
    end

    it 'retuns the Forecast service' do
      expect(subject.send(:request_service).is_a?(Weather::Request::ForecastService))
    end

    it 'returns a successful response' do
      expect(subject.send(:successful_fetch?)).to be(true)
    end

    it 'returns the expected response from GeoLocation' do
      expect(subject.send(:fetch_data)[:response]).to eq(success_response)
    end
  end

  describe 'when using the search method' do
    subject { described_class.new(lat, lng).find }

    before do
      stub_request(:get, 'http://api.openweathermap.org/data/2.5/forecast')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil),
            'lat' => lat,
            'lon' => lng,
            'units' => 'metric'
          }
        )
        .to_return(
          status: 200,
          body: Oj.dump(success_response)
        )
    end

    it 'returns an array' do
      expect(subject.is_a?(Array)).to be(true)
    end

    it 'converts each hash to a model instance' do
      expect(subject.first.is_a?(OpenWeather::Location))
    end

    it 'has an hash with a key and a hash with the data and the datetime instance' do
      date = subject.first

      expect(date.date).to be_present
      expect(date.date.is_a?(DateTime)).to be(true)
      expect(date.forecasts.is_a?(Array)).to be(true)
    end

    it 'has an hash with a key and a hash with the data and the datetime instance' do
      data = subject.first.forecasts.first

      expect(data.is_a?(OpenWeather::Forecast)).to be(true)
      expect(data.date_time.is_a?(DateTime)).to be(true)
      expect(data.temp).to eq(296.76)
      expect(data.feels_like).to eq(296.98)
      expect(data.humidity).to eq(69)
    end
  end

  describe 'when using an invalid API in the request' do
    subject { described_class.new(lat, lng) }

    before do
      stub_request(:get, 'http://api.openweathermap.org/data/2.5/forecast')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil),
            'lat' => lat,
            'lon' => lng,
            'units' => 'metric'
          }
        )
        .to_return(
          status: 401,
          body: Oj.dump(
            {
              'cod' => 401,
              'message' => 'Unauthorised APP key'
            }
          )
        )
    end

    it 'returns a blank array' do
      result = subject.find

      expect(result.is_a?(Hash)).to be(true)
      expect(result.size).to be(0)
    end

    it 'returns a false for a successful_fetch' do
      expect(subject.send(:successful_fetch?)).to be(false)
    end
  end

  describe 'when getting an internal server error' do
    subject { described_class.new(lat, lng) }

    before do
      stub_request(:get, 'http://api.openweathermap.org/data/2.5/forecast')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil),
            'lat' => lat,
            'lon' => lng,
            'units' => 'metric'
          }
        )
        .to_return(
          status: 500,
          body: Oj.dump(
            {
              'cod' => 500,
              'message' => 'Internal server error'
            }
          )
        )
    end

    it 'returns a blank array' do
      result = subject.find

      expect(result.is_a?(Hash)).to be(true)
      expect(result.size).to be(0)
    end

    it 'returns a false for a successful_fetch' do
      expect(subject.send(:successful_fetch?)).to be(false)
    end
  end
end
