# frozen_string_literal: true

module Weather
  module Request
    class GeoLocationService < BaseService
      def initialize(query: nil)
        @query = query
      end

      private

      def path
        '/geo/1.0/direct'
      end

      def params
        {
          q: @query
        }
      end
    end
  end
end
