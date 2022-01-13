# frozen_string_literal: true

git_plugin = self

namespace :prometheus do
  namespace :systemd do
    desc 'Config Prometheus systemd service'
    task :config do
      on roles(fetch(:prometheus_role)) do |role|
        upload_compiled_template = lambda do |template_name, unit_filename|
          git_plugin.template_prometheus template_name, "#{fetch(:tmp_dir)}/#{unit_filename}", role
          systemd_path = fetch(:prometheus_systemd_conf_dir, git_plugin.fetch_systemd_unit_path)
          if fetch(:prometheus_systemctl_user) == :system
            sudo "mv #{fetch(:tmp_dir)}/#{unit_filename} #{systemd_path}"
          else
            execute :mkdir, '-p', systemd_path
            execute :mv, "#{fetch(:tmp_dir)}/#{unit_filename}", systemd_path.to_s
          end
        end

        upload_compiled_template.call('prometheus.service', "#{fetch(:prometheus_service_unit_name)}.service")

        git_plugin.execute_systemd('daemon-reload')
      end
    end

    desc 'Generate service configuration locally'
    task :generate_config_locally do
      fake_role = Struct.new(:hostname)
      run_locally do
        File.write('prometheus.service',
                   git_plugin.compiled_template_prometheus('prometheus.service', fake_role.new('example.com')).string)
      end
    end

    desc 'Enable Prometheus systemd service'
    task :enable do
      on roles(fetch(:prometheus_role)) do
        git_plugin.execute_systemd('enable', fetch(:prometheus_service_unit_name))

        execute :loginctl, 'enable-linger', fetch(:prometheus_lingering_user) if fetch(:prometheus_systemctl_user) != :system && fetch(:prometheus_enable_lingering)
      end
    end

    desc 'Disable Prometheus systemd service'
    task :disable do
      on roles(fetch(:prometheus_role)) do
        git_plugin.execute_systemd('disable', fetch(:prometheus_service_unit_name))
      end
    end
  end

  desc 'Start Prometheus service via systemd'
  task :start do
    on roles(fetch(:prometheus_role)) do
      git_plugin.execute_systemd('start', fetch(:prometheus_service_unit_name))
    end
  end

  desc 'Stop Prometheus service via systemd'
  task :stop do
    on roles(fetch(:prometheus_role)) do
      git_plugin.execute_systemd('stop', fetch(:prometheus_service_unit_name))
    end
  end

  desc 'Restart Prometheus service via systemd'
  task :restart do
    on roles(fetch(:prometheus_role)) do
      git_plugin.execute_systemd('restart', fetch(:prometheus_service_unit_name))
    end
  end

  desc 'Get Prometheus service status via systemd'
  task :status do
    on roles(fetch(:prometheus_role)) do
      git_plugin.execute_systemd('status', fetch(:prometheus_service_unit_name))
    end
  end
end
