# frozen_string_literal: true

Rails.application.routes.draw do
  resources :locations, only: %i[index show] do
    get :export
  end

  root to: 'locations#index'
end
