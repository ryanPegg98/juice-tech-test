# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Weather::Request::ForecastService, type: :model do
  let!(:lat) { 51.5073219 }
  let!(:lng) { 0.1276474  }

  describe 'default methods' do
    subject { described_class.new(lat:, lng:) }

    it 'has a path for the geo location endpoint' do
      expect(subject.send(:path)).to eq('/data/2.5/forecast')
    end

    it 'has the params including the query' do
      expect(subject.send(:params)).to eq({ lat:, lon: lng, units: 'metric' })
    end

    it 'returns a connection instance' do
      expect(subject.send(:connection).is_a?(Faraday::Connection)).to be(true)
    end
  end

  describe 'when requesting an alternative unit' do
    subject { described_class.new(lat:, lng:, units: 'imperial') }

    it 'has the params including the query' do
      expect(subject.send(:params)).to eq({ lat:, lon: lng, units: 'imperial' })
    end
  end

  describe 'when sending the API request' do
    subject { described_class.new(lat:, lng:) }

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
          body: Oj.dump(
            {
              'city' => {
                'id' => 3_163_858,
                'name' => 'Zocca',
                'coord' => {
                  'lon' => lng,
                  'lat' => lat
                }
              },
              'cod' => '200',
              'message' => 0.0582563,
              'cnt' => 7,
              'list' => [
                {
                  'dt' => 1_661_857_200,
                  'sunrise' => 1_661_834_187,
                  'sunset' => 1_661_882_248,
                  'temp' => {
                    'day' => 299.66,
                    'min' => 288.93,
                    'max' => 299.66,
                    'night' => 290.31,
                    'eve' => 297.16,
                    'morn' => 288.93
                  },
                  'feels_like' => {
                    'day' => 299.66,
                    'night' => 290.3,
                    'eve' => 297.1,
                    'morn' => 288.73
                  },
                  'pressure' => 1017,
                  'humidity' => 44,
                  'weather' => [
                    {
                      'id' => 500,
                      'main' => 'Rain',
                      'description' => 'light rain',
                      'icon' => '10d'
                    }
                  ]
                }
              ]
            }
          )
        )
    end

    it 'returns a successful response' do
      expect(subject.fetch[:success]).to be(true)
    end

    it 'returns the status as 200' do
      expect(subject.fetch[:status]).to be(200)
    end

    it 'returns keys for the cordinates, weather and some other information' do
      expected = {
        'city' => {
          'id' => 3_163_858,
          'name' => 'Zocca',
          'coord' => {
            'lon' => lng,
            'lat' => lat
          }
        },
        'cod' => '200',
        'message' => 0.0582563,
        'cnt' => 7,
        'list' => [
          {
            'dt' => 1_661_857_200,
            'sunrise' => 1_661_834_187,
            'sunset' => 1_661_882_248,
            'temp' => {
              'day' => 299.66,
              'min' => 288.93,
              'max' => 299.66,
              'night' => 290.31,
              'eve' => 297.16,
              'morn' => 288.93
            },
            'feels_like' => {
              'day' => 299.66,
              'night' => 290.3,
              'eve' => 297.1,
              'morn' => 288.73
            },
            'pressure' => 1017,
            'humidity' => 44,
            'weather' => [
              {
                'id' => 500,
                'main' => 'Rain',
                'description' => 'light rain',
                'icon' => '10d'
              }
            ]
          }
        ]
      }

      expect(subject.fetch[:response]).to eq(expected)
    end
  end

  describe 'when sending a failed API request' do
    subject { described_class.new(lat:, lng:) }

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
              'message' => 'Unauthorized APP Key'
            }
          )
        )
    end

    it 'returns a successful response' do
      expect(subject.fetch[:success]).to be(false)
    end

    it 'returns the status as 200' do
      expect(subject.fetch[:status]).to be(401)
    end

    it 'returns the a hash of the response' do
      expected = {
        'cod' => 401,
        'message' => 'Unauthorized APP Key'
      }

      expect(subject.fetch[:response]).to eq(expected)
    end
  end
end
