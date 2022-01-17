# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { reading: :primary, writing: :primary }

  def log_name
    return "#{name} (#{id})" if respond_to?(:name)

    "#{self.class.name}##{id}"
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

  def markets_reader
    Kredis.redis(config: :markets_reader)
  end

  def markets_writer
    Kredis.redis(config: :markets_writer)
  end

  def orders_reader
    Kredis.redis(config: :orders_reader)
  end

  def orders_writer
    Kredis.redis(config: :orders_writer)
  end
end
