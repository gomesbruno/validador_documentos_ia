# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 2.7.0'

source 'https://app.sti.uff.br/nexus/repository/rubygems/' do
  gem 'http_error_pages'
  gem 'iduff-keycloak_client', '1.3'
  gem 'publico-core', '3.0.2'
end

# gem 'activerecord-oracle_enhanced-adapter', '~> 6.0.0'
gem 'bootsnap', '>= 1.16.0', require: false
gem 'puma', '~> 3.11'
gem 'rails', '>= 6.0'
gem 'secure_headers'
gem 'webpacker'

gem 'jquery-rails', '4.3.1'
gem 'jquery-ui-rails', '6.0.1'
gem 'numbers_and_words', '0.11.6'
gem 'premailer-rails', '1.10.3'
gem 'rails-assets-sweetalert2', '~> 5.1.1', source: 'https://rails-assets.org'
gem 'rails-jquery-autocomplete', '1.0.5'
gem 'rails-observers', '0.1.5'

gem 'jquery-datatables'
gem 'js-routes', '1.4.4'
gem 'rails-assets-datatables', '1.10.19', source: 'https://rails-assets.org'
gem 'sprockets-rails', '>= 3.2.1'

# Chose which database you wish to use
# gem 'sqlite3'
gem 'mysql2', '0.5.1'

gem 'paper_trail', '~> 12.3'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

group :production, :homologacao do
  gem 'exception_notification'
  # gem 'newrelic_rpm', '5.2.0.345'
  # gem 'SyslogLogger', '2.0'
end

group :development do
  # gem 'better_errors', '2.4.0'
  # gem 'binding_of_caller'
  # Para envios de email (testes em dev)
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # gem 'bullet', '5.7.5'
  gem 'web-console', '~> 4.1'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot_rails', require: true
  gem 'rspec-rails'
  gem 'shoulda-matchers', require: false
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'awesome_print'
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'pry-rails'
  gem 'spring'
  gem 'email_spec'
end
