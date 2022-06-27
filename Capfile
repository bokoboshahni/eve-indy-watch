# frozen_string_literal: true

require 'dotenv/load'

require 'bcrypt_pbkdf'
require 'ed25519'

require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/rails/console'

require 'capistrano/puma'
install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Systemd

require 'capistrano/sidekiq'
install_plugin Capistrano::Sidekiq
install_plugin Capistrano::Sidekiq::Systemd

require_relative './lib/capistrano/prometheus'
install_plugin Capistrano::Prometheus
install_plugin Capistrano::Prometheus::Systemd

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
