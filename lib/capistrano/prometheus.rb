require 'capistrano/bundler'
require 'capistrano/plugin'

module Capistrano
  module PrometheusCommon
    def prometheus_switch_user(role, &block)
      user = prometheus_user(role)
      if user == role.user
        block.call
      else
        backend.as user do
          block.call
        end
      end
    end

    def prometheus_user(role)
      properties = role.properties
      properties.fetch(:prometheus_user) || # local property for prometheus only
          fetch(:prometheus_user) ||
          properties.fetch(:run_as) || # global property across multiple capistrano gems
          role.user
    end

    def compiled_template_prometheus(from, role)
      @role = role
      file = [
          "lib/capistrano/templates/#{from}-#{role.hostname}-#{fetch(:stage)}.rb",
          "lib/capistrano/templates/#{from}-#{role.hostname}.rb",
          "lib/capistrano/templates/#{from}-#{fetch(:stage)}.rb",
          "lib/capistrano/templates/#{from}.rb.erb",
          "lib/capistrano/templates/#{from}.rb",
          "lib/capistrano/templates/#{from}.erb",
          "config/deploy/templates/#{from}.rb.erb",
          "config/deploy/templates/#{from}.rb",
          "config/deploy/templates/#{from}.erb",
          File.expand_path("../templates/#{from}.erb", __FILE__),
          File.expand_path("../templates/#{from}.rb.erb", __FILE__)
      ].detect { |path| File.file?(path) }
      erb = File.read(file)
      StringIO.new(ERB.new(erb, nil, '-').result(binding))
    end

    def template_prometheus(from, to, role)
      backend.upload! compiled_template_prometheus(from, role), to
    end
  end

  class Prometheus < Capistrano::Plugin
    include PrometheusCommon

    def set_defaults
      set_if_empty :prometheus_role, :app
      set_if_empty :prometheus_env, -> { fetch(:rack_env, fetch(:rails_env, fetch(:stage))) }
      set_if_empty :prometheus_bind_address, 'localhost'
      set_if_empty :prometheus_bind_port, 9394
      set_if_empty :prometheus_access_log, -> { File.join(shared_path, 'log', 'prometheus_access.log') }
      set_if_empty :prometheus_error_log, -> { File.join(shared_path, 'log', 'prometheus_error.log') }
      set_if_empty :prometheus_label, {}
      set_if_empty :prometheus_timeout, 1
      set_if_empty :prometheus_custom_collectors, []
      set_if_empty :prometheus_prefix, nil

      append :bundle_bins, 'prometheus_exporter'
    end
  end
end

require_relative './prometheus/systemd'
