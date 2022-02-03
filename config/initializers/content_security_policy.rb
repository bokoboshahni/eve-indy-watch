# frozen_string_literal: true

if Rails.env.development?
  Rails.application.config.content_security_policy do |policy|
    policy.default_src :self, :http, :https, :ws
    policy.font_src    :self, :http, :https, :data
    policy.img_src     :self, :http, :https, :data
    policy.object_src  :none
    policy.script_src  :self, :http, :https, :unsafe_inline
    policy.style_src   :self, :http, :https, :unsafe_inline

    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # If you are using UJS then enable automatic nonce generation
else
  asset_host = ENV.fetch('RAILS_ASSET_HOST', '')
  Rails.application.config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data, asset_host
    policy.img_src     :self, :https, :data, asset_host
    policy.object_src  :none
    policy.script_src  :self, :https, :unsafe_inline, asset_host
    policy.style_src   :self, :https, :unsafe_inline, asset_host

    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # If you are using UJS then enable automatic nonce generation
end

Rails.application.config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
Rails.application.config.content_security_policy_nonce_directives = %w[script-src]
