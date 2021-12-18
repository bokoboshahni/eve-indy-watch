# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.16.0'

Rake::Task['deploy:assets:backup_manifest'].clear_actions

SSHKit.config.command_map[:sidekiq] = 'bundle exec sidekiq'
SSHKit.config.command_map[:sidekiqctl] = 'bundle exec sidekiqctl'
SSHKit.config.umask = '022'

set :application, ENV.fetch('DEPLOY_APPLICATION', 'eve-indy-watch')
set :repo_url, ENV.fetch('DEPLOY_REPO_URL', 'https://github.com/bokoboshahni/eve-indy-watch.git')
set :branch, ENV.fetch('DEPLOY_BRANCH', 'main')
set :deploy_to, ENV.fetch('DEPLOY_DIR', '/var/www/eve-indy-watch')

append :linked_files, '.env'
append :linked_dirs, 'log', 'node_modules', 'tmp', 'vendor/bundle'

set :keep_releases, ENV.fetch('DEPLOY_KEEP_RELEASES', 1).to_i

set :puma_phased_restart, true
set :puma_systemctl_user, :user
set :puma_preload_app, true
set :puma_init_active_record, true

set :sidekiq_service_unit_user, :user
set :sidekiq_processes, ENV.fetch('SIDEKIQ_PROCESSES', 4).to_i
set :sidekiq_concurrency, ENV.fetch('SIDEKIQ_CONCURRENCY', 25).to_i
set :sidekiq_config, 'config/sidekiq.yml'

namespace :deploy do
  desc 'Load database schema from structure.sql'
  task :db_schema_load do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env), DISABLE_DATABASE_ENVIRONMENT_CHECK: '1' do
          execute :rake, 'db:schema:load'
        end
      end
    end
  end
end

namespace :sde do
  desc 'Download the latest SDE'
  task :download do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'sde:download'
        end
      end
    end
  end

  desc 'Load the SDE'
  task :load do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'sde:load'
        end
      end
    end
  end
end

namespace :fittings do
  desc 'Import fittings from shared/tmp/fittings'
  task :import_eft_files do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'fittings:import_eft_files'
        end
      end
    end
  end
end

namespace :search do
  desc 'Rebuild all multisearch indices'
  task :rebuild_all do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'search:rebuild_all'
        end
      end
    end
  end
end

before 'deploy:migrate', 'deploy:db_schema_load' if ENV['DB_SCHEMA_LOAD']
