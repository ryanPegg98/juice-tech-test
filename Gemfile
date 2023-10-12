# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.1'

gem 'bootsnap', require: false
gem 'dotenv-rails', '~> 2.8', '>= 2.8.1'
gem 'importmap-rails'
gem 'jbuilder'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.8'
gem 'sassc-rails'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# gem "redis", "~> 4.0"
# gem "kredis"
# gem "bcrypt", "~> 3.1.7"
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem 'database_cleaner', '~> 2.0', '>= 2.0.2'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.2', '>= 3.2.1'
  gem 'rspec-rails', '~> 6.0', '>= 6.0.3'
  gem 'rubocop-factory_bot', '~> 2.24', require: false
  gem 'rubocop-rails', '~> 2.21', '>= 2.21.2', require: false
  gem 'rubocop-rspec', '~> 2.24', '>= 2.24.1', require: false
  gem 'shoulda-matchers', '~> 5.3'
end

group :development do
  gem 'web-console'

  # gem "rack-mini-profiler"
  # gem "spring"
end
