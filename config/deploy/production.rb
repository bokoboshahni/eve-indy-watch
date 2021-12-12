# frozen_string_literal: true

set :stage, :production

role :app, ENV.fetch('DEPLOY_PRODUCTION_ROLES_APP', '').split(',')
role :web, ENV.fetch('DEPLOY_PRODUCTION_ROLES_WEB', '').split(',')
role :db, ENV.fetch('DEPLOY_PRODUCTION_ROLES_DB', '').split(',')

set :sidekiq_processes, ENV.fetch('SIDEKIQ_PROCESSES', 6).to_i
