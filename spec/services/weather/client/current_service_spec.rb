# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Weather::Client::CurrentService, type: :model do
  describe 'default methods' do
    subject { described_class.new(lat, lng) }

    let!(:lat) { 51.5073219 }
    let!(:lng) { -0.1276474 }

    before do
      stub_request(:get, 'http://api.openweathermap.org/data/2.5/weather')
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
          body: Oj.dump(
            {
              'coord' => {
                'lon' => lng,
                'lat' => lat
              },
              weather: [
                {
                  'id' => 501,
                  'main' => 'Rain',
                  'description' => 'moderate rain',
                  'icon' => '10d'
                }
              ],
              'main' => {
                'temp' => 20,
                'feels_like' => 19,
                'humidity' => 77
              },
              'wind' => {
                'speed' => 9.25
              },
              'base' => 'stations',
              'timezone' => 7200,
              'id' => 3_163_858,
              'name' => 'Zocca',
              'cod' => 200
            }
          )
        )
    end

    it 'retuns the Current service' do
      expect(subject.send(:request_service).is_a?(Weather::Request::CurrentService))
    end

    it 'returns a successful response' do
      expect(subject.send(:successful_fetch?)).to be(true)
    end

    it 'returns the expected response from Current' do
      expected = {
        'coord' => {
          'lon' => lng,
          'lat' => lat
        },
        weather: [
          {
            'id' => 501,
            'main' => 'Rain',
            'description' => 'moderate rain',
            'icon' => '10d'
          }
        ],
        'main' => {
          'temp' => 20,
          'feels_like' => 19,
          'humidity' => 77
        },
        'wind' => {
          'speed' => 9.25
        },
        'base' => 'stations',
        'timezone' => 7200,
        'id' => 3_163_858,
        'name' => 'Zocca',
        'cod' => 200
      }

      expect(subject.send(:fetch_data)[:response]).to eq(expected)
    end
  end

  describe 'when using the search method' do
    subject { described_class.new(lat, lng).find }

    let!(:lat) { 51.5073219 }
    let!(:lng) { -0.1276474 }

    before do
      stub_request(:get, 'http://api.openweathermap.org/data/2.5/weather')
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
          body: Oj.dump(
            {
              'coord' => {
                'lon' => lng,
                'lat' => lat
              },
              'weather' => [
                {
                  'id' => 501,
                  'main' => 'Rain',
                  'description' => 'moderate rain',
                  'icon' => '10d'
                }
              ],
              'main' => {
                'temp' => 20,
                'feels_like' => 19,
                'humidity' => 77
              },
              'wind' => {
                'speed' => 9.25
              },
              'base' => 'stations',
              'timezone' => 7200,
              'id' => 3_163_858,
              'name' => 'Zocca',
              'cod' => 200
            }
          )
        )
    end

    it 'returns an Forecast instance' do
      expect(subject.is_a?(OpenWeather::Forecast)).to be(true)
    end

    it 'has copied over the data to the model instance' do
      expect(subject.temp).to eq(20)
      expect(subject.feels_like).to eq(19)
      expect(subject.weather).to eq(['Moderate rain'])
      expect(subject.humidity).to eq(77)
      expect(subject.wind_speed).to eq(9.25)
    end
  end

  describe 'when using an invalid API in the request' do
    subject { described_class.new(lat, lng) }

    let!(:lat) { 51.5073219 }
    let!(:lng) { -0.1276474 }

    before do
      stub_request(:get, 'http://api.openweathermap.org/data/2.5/weather')
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

    it 'returns a nil value' do
      result = subject.find

      expect(result).to be_nil
    end

    it 'returns a false for a successful_fetch' do
      expect(subject.send(:successful_fetch?)).to be(false)
    end
  end

  describe 'when getting an internal server error' do
    subject { described_class.new(lat, lng) }

    let!(:lat) { 51.5073219 }
    let!(:lng) { -0.1276474 }

    before do
      stub_request(:get, 'http://api.openweathermap.org/data/2.5/weather')
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
              'message' => 'Internal Server Error'
            }
          )
        )
    end

    it 'returns a blank array' do
      result = subject.find

      expect(result).to be_nil
    end

    it 'returns a false for a successful_fetch' do
      expect(subject.send(:successful_fetch?)).to be(false)
    end
  end
end
