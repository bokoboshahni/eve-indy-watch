# frozen_string_literal: true

role :app, ENV.fetch('DEPLOY_STAGING_ROLES_APP', '').split(',')
role :web, ENV.fetch('DEPLOY_STAGING_ROLES_WEB', '').split(',')
role :db, ENV.fetch('DEPLOY_STAGING_ROLES_DB', '').split(',')
role :worker, ENV.fetch('DEPLOY_STAGING_ROLES_WORKER', '').split(',')

set :sidekiq_processes, ENV.fetch('DEPLOY_PRODUCTION_SIDEKIQ_PROCESSES', 6).to_i
set :sidekiq_concurrency, ENV.fetch('DEPLOY_PRODUCTION_SIDEKIQ_CONCURRENCY', 10).to_i

set :branch, Regexp.last_match(1) if `git branch` =~ /\* (\S+)\s/m
