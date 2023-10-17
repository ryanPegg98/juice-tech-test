# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Weather::Request::GeoLocationService, type: :model do
  describe 'default methods' do
    subject { described_class.new(query: 'London, GB') }

    it 'has a path for the geo location endpoint' do
      expect(subject.send(:path)).to eq('/geo/1.0/direct')
    end

    it 'has the params including the query' do
      expect(subject.send(:params)).to eq({ q: 'London, GB' })
    end

    it 'returns a connection instance' do
      expect(subject.send(:connection).is_a?(Faraday::Connection)).to be(true)
    end
  end

  describe 'when sending the API request' do
    subject { described_class.new(query: city) }

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

    it 'returns a successful response' do
      expect(subject.fetch[:success]).to be(true)
    end

    it 'returns the status as 200' do
      expect(subject.fetch[:status]).to be(200)
    end

    it 'returns the a list of one hash' do
      expect(subject.fetch[:response].size).to be(1)
    end

    it 'returns the first hash of the location' do
      expected = {
        'name' => 'London',
        'local_names' => {},
        'lat' => 51.5073219,
        'lon' => -0.1276474,
        'country' => 'GB',
        'state' => 'England'
      }

      expect(subject.fetch[:response].first).to eq(expected)
    end
  end

  describe 'when sending a failed API request' do
    subject { described_class.new(query: city) }

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
