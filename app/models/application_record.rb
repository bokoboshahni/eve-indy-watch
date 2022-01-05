# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { reading: :primary, writing: :primary }

  def log_name
    "#{name} (#{id})"
  end

  protected

  def main_alliance
    @main_alliance ||= Alliance.find(main_alliance_id)
  end

  def main_alliance_id
    app_config.main_alliance_id
  end

  def app_config
    Rails.application.config.x.app
  end

  def markets_redis
    @markets_redis ||= Kredis.redis(config: :markets)
  end
end
