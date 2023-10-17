# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locations' do
  let!(:forecast_success_response) do
    {
      'cod' => '200',
      'message' => 0,
      'cnt' => 40,
      'list' => [
        {
          'dt' => 1_661_871_600,
          'main' => {
            'temp' => 20.76,
            'feels_like' => 18.98,
            'humidity' => 69
          },
          'weather' => [
            {
              'id' => 500,
              'main' => 'Rain',
              'description' => 'light rain',
              'icon' => '10d'
            }
          ],
          wind: {
            'speed' => 0.62
          }
        },
        {
          'dt' => 1_661_882_400,
          'main' => {
            'temp' => 22.45,
            'feels_like' => 21.59,
            'humidity' => 71
          },
          weather: [
            {
              'id' => 500,
              'main' => 'Rain',
              'description' => 'light rain',
              'icon' => '10n'
            }
          ],
          wind: {
            'speed' => 1.97
          }
        }
      ]
    }
  end
  let!(:location_success_response) do
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
  end
  let!(:current_success_response) do
    {
      'coord' => {
        'lon' => -0.1276474,
        'lat' => 51.5073219
      },
      weather: [
        {
          'id' => 501,
          'main' => 'Rain',
          'description' => 'moderate rain',
          'icon' => '10d'
        }
      ],
      'main' => {
        'temp' => 20,
        'feels_like' => 19,
        'humidity' => 77
      },
      'wind' => {
        'speed' => 9.25
      },
      'base' => 'stations',
      'timezone' => 7200,
      'id' => 3_163_858,
      'name' => 'Zocca',
      'cod' => 200
    }
  end

  let!(:internal_server_error) do
    {
      'cod' => 500,
      'message' => 'Internal Server Error'
    }
  end

  context 'when searching for a location' do
    before do
      stub_request(:get, 'http://api.openweathermap.org/geo/1.0/direct')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil),
            'q' => 'London'
          }
        )
        .to_return(
          status: 200,
          body: Oj.dump(location_success_response)
        )
    end

    it 'I should be able to search and see London as the result' do
      visit locations_path

      within '*[data-target="message"]' do
        expect(page).to have_content('No locations found.')
      end

      fill_in :search_term, with: 'London'
      click_button 'search'

      within '*[data-target="location_results"]' do
        expect(page).to have_content('London')
        expect(page).to have_content('GB')
      end
    end
  end

  context 'when getting an error from the API endpoint' do
    before do
      stub_request(:get, 'http://api.openweathermap.org/geo/1.0/direct')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil),
            'q' => 'London'
          }
        )
        .to_return(
          status: 500,
          body: Oj.dump(internal_server_error)
        )
    end

    it 'I should see that no locations can be found' do
      visit locations_path

      within '*[data-target="message"]' do
        expect(page).to have_content('No locations found.')
      end

      fill_in :search_term, with: 'London'
      click_button 'search'

      within '*[data-target="message"]' do
        expect(page).to have_content('No locations found.')
      end
    end
  end

  context 'when looking at the current weather for a location' do
    before do
      stub_request(:get, 'http://api.openweathermap.org/geo/1.0/direct')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil),
            'q' => 'London'
          }
        )
        .to_return(
          status: 200,
          body: Oj.dump(location_success_response)
        )

      stub_request(:get, 'http://api.openweathermap.org/data/2.5/weather')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil),
            'lat' => 51.5073219,
            'lon' => -0.1276474,
            'units' => 'metric'
          }
        )
        .to_return(
          status: 200,
          body: Oj.dump(current_success_response)
        )

      stub_request(:get, 'http://api.openweathermap.org/data/2.5/forecast')
        .with(
          query: {
            'appid' => ENV.fetch('OPEN_WEATHER_KEY', nil),
            'lat' => 51.5073219,
            'lon' => -0.1276474,
            'units' => 'metric'
          }
        )
        .to_return(
          status: 200,
          body: Oj.dump(forecast_success_response)
        )
    end

    it 'I should be able to see the current weather of a selected location' do
      visit locations_path

      fill_in :search_term, with: 'London'
      click_button 'search'

      within '*[data-target="location_results"]' do
        click_link 'Show'
      end

      expect(page).to have_content('London')

      within '*[data-target="current_temp"]' do
        expect(page).to have_content('20°C')
      end
    end

    it 'should be able to see the forecasted weather of a selected location' do
      visit locations_path

      fill_in :search_term, with: 'London'
      click_button 'search'

      within '*[data-target="location_results"]' do
        click_link 'Show'
      end

      expect(page).to have_content('London')

      within '*[data-target="forecast_hour_1661871600"]' do
        expect(page).to have_content('Temp: 20.76°C')
        expect(page).to have_content('Humidity: 69%')
      end

      within '*[data-target="forecast_hour_1661882400"]' do
        expect(page).to have_content('Temp: 22.45°C')
        expect(page).to have_content('Humidity: 71%')
      end
    end

    it "should be able to click the export link" do
      visit locations_path

      fill_in :search_term, with: 'London'
      click_button 'search'

      within '*[data-target="location_results"]' do
        click_link 'Show'
      end

      expect(page).to have_content('London')

      within '*[data-target="forecast"]' do
        expect(page).to have_link(
          'Export (CSV)',
          href: location_export_path(
            location_id: 'GB',
            lat: 51.5073219,
            lng: -0.1276474,
            name: 'London'
          )
        )
      end
    end
  end
end
