# frozen_string_literal: true

module OpenWeather
  class Location
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :lat
    attribute :lng
    attribute :name
    attribute :country

    def persisted?
      true
    end
  end
end
