# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Weather::Request::BaseService, type: :model do
  describe 'private methods' do
    subject { described_class.new }

    it 'returns the API key in the environment variables' do
      expect(subject.send(:api_key)).to eq(ENV.fetch('OPEN_WEATHER_KEY', nil))
    end

    it 'returns a Faraday connection instance for connection' do
      connection = subject.send(:connection)

      expect(connection.is_a?(Faraday::Connection)).to be(true)
      expect(connection.url_prefix.to_s).to eq('http://api.openweathermap.org/')
      expect(connection.params).to eq({ 'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil) })
    end

    it 'has a method to define the path' do
      expect(subject.send(:path)).to eq('/')
    end

    it 'has a method to define the parameters' do
      expect(subject.send(:params)).to eq({})
    end
  end

  describe 'when sending an API request' do
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

    it 'returns a response instance when sending the request' do
      response = subject.send(:send_request)

      expect(response.is_a?(Faraday::Response)).to be(true)
      expect(response.status).to be(200)
      expect(response.body).to eq(Oj.dump({ 'key' => 'value' }))
    end

    it 'returns a hash when formatting the respone' do
      response = subject.send(:send_request)
      formatted_response = subject.send(:format_response, response)

      expect(formatted_response.is_a?(Hash)).to be(true)
      expect(formatted_response[:success]).to be(true)
      expect(formatted_response[:status]).to be(200)
      expect(formatted_response[:response]).to eq({ 'key' => 'value' })
    end

    it 'combines the send_request and format_repsonse method' do
      fetch = subject.fetch

      expect(fetch.is_a?(Hash)).to be(true)
      expect(fetch[:success]).to be(true)
      expect(fetch[:status]).to be(200)
      expect(fetch[:response]).to eq({ 'key' => 'value' })
    end
  end

  describe 'when a unsuccessful request is made' do
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
          body: Oj.dump({ 'message' => 'Server Error' })
        )
    end

    it 'returns a response hash' do
      response = subject.send(:send_request)
      formatted_response = subject.send(:format_response, response)

      expect(formatted_response.is_a?(Hash)).to be(true)
      expect(formatted_response[:success]).to be(false)
      expect(formatted_response[:status]).to be(500)
      expect(formatted_response.dig(:response, 'message')).to eq('Server Error')
    end

    it 'returns a response hash when using fetch' do
      fetch = subject.fetch

      expect(fetch.is_a?(Hash)).to be(true)
      expect(fetch[:success]).to be(false)
      expect(fetch[:status]).to be(500)
      expect(fetch.dig(:response, 'message')).to eq('Server Error')
    end
  end
end
