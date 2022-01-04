module Capistrano
  class Prometheus::Systemd < Capistrano::Plugin
    include PrometheusCommon

    def register_hooks
      after 'deploy:finished', 'prometheus:restart'
    end

    def define_tasks
      eval_rakefile File.expand_path('../systemd.rake', __FILE__)
    end

    def set_defaults
      set_if_empty :prometheus_systemctl_bin, '/bin/systemctl'
      set_if_empty :prometheus_service_unit_name, -> { "prometheus_#{fetch(:application)}_#{fetch(:stage)}" }
      set_if_empty :prometheus_enable_lingering, true
      set_if_empty :prometheus_lingering_user, -> { fetch(:user) }
    end

    def expanded_bundle_command
      backend.capture(:echo, SSHKit.config.command_map[:bundle]).strip
    end

    def fetch_systemd_unit_path
      home_dir = backend.capture :pwd
      File.join(home_dir, ".config", "systemd", "user")
    end

    def systemd_command(*args)
      command = [fetch(:prometheus_systemctl_bin)]
      command << "--user"
      command + args
    end

    def sudo_if_needed(*command)
      backend.execute(*command)
    end

    def execute_systemd(*args)
      sudo_if_needed(*systemd_command(*args))
    end
  end
end
