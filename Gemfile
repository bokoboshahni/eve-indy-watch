# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'dotenv-rails', '~> 2.7', groups: %i[development test]

gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'jbuilder', '~> 2.7'
gem 'webpacker', '~> 5.4.0'
gem 'stimulus-rails', '~> 0.7'
gem 'turbo-rails', '~> 0.9'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'esi-sdk', '~> 2.1'
gem 'local_time', '~> 2.1'
gem 'lockbox', '~> 0.6'
gem 'oauth2', '~> 1.4'
gem 'omniauth-eve_online-sso', '~> 0.5'
gem 'omniauth-rails_csrf_protection', '~> 1.0'
gem 'heroicon', '~> 0.4'
gem 'pagy', '~> 5.6'

group :development, :test do
  gem 'byebug', '~> 11.1'
  gem 'rspec-rails', '~> 5.0'
end

group :development do
  gem 'annotate', '~> 3.1'
  gem 'web-console', '>= 4.1.0'
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'rubocop', '~> 1.23'
  gem 'rubocop-performance', '~> 1.12'
  gem 'rubocop-rails', '~> 2.12'
  gem 'rubocop-rspec', '~> 2.6'
end
