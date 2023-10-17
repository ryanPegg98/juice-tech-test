# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Weather::Client::GeoLocationService, type: :model do
  describe 'default methods' do
    subject { described_class.new(city) }

    let!(:city) { 'London, GB' }

    before do
      stub_request(:get, 'http://api.openweathermap.org/geo/1.0/direct')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil),
            'q' => city
          }
        )
        .to_return(
          status: 200,
          body: Oj.dump(
            [
              {
                'name' => 'London',
                'local_names' => {},
                'lat' => 51.5073219,
                'lon' => -0.1276474,
                'country' => 'GB',
                'state' => 'England'
              }
            ]
          )
        )
    end

    it 'retuns the GeoLocation service' do
      expect(subject.send(:request_service).is_a?(Weather::Request::GeoLocationService))
    end

    it 'returns a successful response' do
      expect(subject.send(:successful_fetch?)).to be(true)
    end

    it 'returns the expected response from GeoLocation' do
      expected = {
        'name' => 'London',
        'local_names' => {},
        'lat' => 51.5073219,
        'lon' => -0.1276474,
        'country' => 'GB',
        'state' => 'England'
      }

      expect(subject.send(:fetch_data)[:response].first).to eq(expected)
    end
  end

  describe 'when using the search method' do
    subject { described_class.new(city).search }

    let!(:city) { 'London, GB' }

    before do
      stub_request(:get, 'http://api.openweathermap.org/geo/1.0/direct')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil),
            'q' => city
          }
        )
        .to_return(
          status: 200,
          body: Oj.dump(
            [
              {
                'name' => 'London',
                'local_names' => {},
                'lat' => 51.5073219,
                'lon' => -0.1276474,
                'country' => 'GB',
                'state' => 'England'
              }
            ]
          )
        )
    end

    it 'returns an array' do
      expect(subject.is_a?(Array)).to be(true)
      expect(subject.size).to be(1)
    end

    it 'converts each hash to a model instance' do
      expect(subject.first.is_a?(OpenWeather::Location))
    end

    it 'has copied over the data to the model instance' do
      location = subject.first

      expect(location.lat).to eq(51.5073219)
      expect(location.lng).to eq(-0.1276474)
      expect(location.name).to eq('London')
      expect(location.country).to eq('GB')
    end
  end

  describe 'when using an invalid API in the request' do
    subject { described_class.new(city) }

    let!(:city) { 'London, GB' }

    before do
      stub_request(:get, 'http://api.openweathermap.org/geo/1.0/direct')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil),
            'q' => city
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
      result = subject.search

      expect(result.is_a?(Array)).to be(true)
      expect(result.size).to be(0)
    end

    it 'returns a false for a successful_fetch' do
      expect(subject.send(:successful_fetch?)).to be(false)
    end
  end

  describe 'when getting an internal server error' do
    subject { described_class.new(city) }

    let!(:city) { 'London, GB' }

    before do
      stub_request(:get, 'http://api.openweathermap.org/geo/1.0/direct')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil),
            'q' => city
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
      result = subject.search

      expect(result.is_a?(Array)).to be(true)
      expect(result.size).to be(0)
    end

    it 'returns a false for a successful_fetch' do
      expect(subject.send(:successful_fetch?)).to be(false)
    end
  end
end
