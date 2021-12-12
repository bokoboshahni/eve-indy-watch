role :app, ENV.fetch('DEPLOY_STAGING_ROLES_APP', '').split(',')
role :web, ENV.fetch('DEPLOY_STAGING_ROLES_WEB', '').split(',')
role :db, ENV.fetch('DEPLOY_STAGING_ROLES_DB', '').split(',')

set :sidekiq_processes, ENV.fetch('SIDEKIQ_PROCESSES', 6).to_i
