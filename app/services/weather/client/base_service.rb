# frozen_string_literal: true

module Weather
  module Client
    class BaseService
      private

      def successful_fetch?
        fetch_data[:success]
      end

      def fetch_data
        @fetch_data ||= request_service.fetch
      end

      def request_service
        @request_service ||= Weather::Request::BaseService.new
      end
    end
  end
end
