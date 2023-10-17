# frozen_string_literal: true

class LocationsController < ApplicationController
  before_action :set_location_search, only: :index
  before_action :set_location, only: %i[show export]
  before_action :capture_forecast, only: %i[show export]

  def index
    @locations = searching? ? search_data : []
  end

  def show
    @current_weather = Weather::Client::CurrentService.find(@location.lat, @location.lng)
  end

  def export
    @export = WeatherExportService.new(params[:name], @forecasts)

    send_data @export.export, filename: @export.filename
  end

  private

  def set_location_search
    @search = OpenWeather::LocationSearch.new(search_params)
  end

  def set_location
    @location = OpenWeather::Location.new(
      name: params[:name],
      lat: params[:lat],
      lng: params[:lng],
      country: params[:location_id].presence || params[:id]
    )
  end

  def capture_forecast
    @forecasts = Weather::Client::ForecastService.find(@location.lat, @location.lng)
  end

  def searching?
    @search.term.present?
  end

  def search_data
    @search_data ||= Weather::Client::GeoLocationService.search(@search.term)
  end

  def search_params
    params.require(:search)&.permit(:term) if params[:search].present?
  end
end
