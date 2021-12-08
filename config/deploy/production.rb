set :stage, :production

role :app, ENV.fetch('DEPLOY_PRODUCTION_ROLES_APP', '').split(',')
role :web, ENV.fetch('DEPLOY_PRODUCTION_ROLES_WEB', '').split(',')
role :db, ENV.fetch('DEPLOY_PRODUCTION_ROLES_DB', '').split(',')
