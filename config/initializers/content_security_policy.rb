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
  Rails.application.config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  Rails.application.config.content_security_policy_nonce_directives = %w(script-src)
else
  Rails.application.config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data, ENV['RAILS_ASSET_HOST']
    policy.img_src     :self, :https, :data, ENV['RAILS_ASSET_HOST']
    policy.object_src  :none
    policy.script_src  :self, :https, :unsafe_inline, ENV['RAILS_ASSET_HOST']
    policy.style_src   :self, :https, :unsafe_inline, ENV['RAILS_ASSET_HOST']

    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # If you are using UJS then enable automatic nonce generation
  Rails.application.config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  Rails.application.config.content_security_policy_nonce_directives = %w(script-src)
end
