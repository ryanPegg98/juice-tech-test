# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Weather::Client::BaseService, type: :model do
  describe 'default methods' do
    subject { described_class.new }

    before do
      stub_request(:get, 'http://api.openweathermap.org/')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil)
          }
        )
        .to_return(
          status: 200,
          body: Oj.dump({ 'key' => 'value' })
        )
    end

    it 'returns an instance if the base request service' do
      expect(subject.send(:request_service).is_a?(Weather::Request::BaseService)).to be(true)
    end

    it 'returns a hash from the request service' do
      expect(subject.send(:fetch_data).is_a?(Hash)).to be(true)
      expect(subject.send(:fetch_data)[:response]).to eq({ 'key' => 'value' })
    end

    it 'returns true when checking if it was successful' do
      expect(subject.send(:successful_fetch?)).to be(true)
    end
  end

  describe 'when using an invalid APP key' do
    subject { described_class.new }

    before do
      stub_request(:get, 'http://api.openweathermap.org/')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil)
          }
        )
        .to_return(
          status: 401,
          body: Oj.dump({ 'cod' => 401, 'message' => 'Unauthorized APP Key' })
        )
    end

    it 'returns false for the successful_fetch? method' do
      expect(subject.send(:successful_fetch?)).to be(false)
    end
  end

  describe 'when using getting an internal server error' do
    subject { described_class.new }

    before do
      stub_request(:get, 'http://api.openweathermap.org/')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil)
          }
        )
        .to_return(
          status: 500,
          body: Oj.dump({ 'cod' => 500, 'message' => 'Internal Server Error' })
        )
    end

    it 'returns false for the successful_fetch? method' do
      expect(subject.send(:successful_fetch?)).to be(false)
    end
  end
end
