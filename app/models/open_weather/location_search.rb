# frozen_string_literal: true

module OpenWeather
  class LocationSearch
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :term
  end
end
