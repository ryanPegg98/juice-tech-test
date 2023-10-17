# frozen_string_literal: true

module OpenWeather
  class Location
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :lat
    attribute :lng
    attribute :name
    attribute :country

  end
end
