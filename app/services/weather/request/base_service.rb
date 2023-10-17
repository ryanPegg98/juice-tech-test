# frozen_string_literal: true

module Weather
  module Request
    class BaseService
      DOMAIN = 'http://api.openweathermap.org'

      def fetch
        format_response(send_request)
      end

      private

      def format_response(response)
        {
          success: [200, 201].include?(response.status),
          status: response.status,
          response: Oj.load(response.body)
        }
      end

      def params
        {}
      end

      def path
        '/'
      end

      def send_request
        connection.get(path) do |req|
          params.each do |key, value|
            req.params[key] = value
          end
        end
      end

      def connection
        @connection ||= Faraday.new(
          url: DOMAIN,
          params: { appid: api_key },
          headers: {
            'Content-Type' => 'application/json'
          }
        )
      end

      def api_key
        ENV.fetch('OPEN_WEATHER_KEY', nil)
      end
    end
  end
end
