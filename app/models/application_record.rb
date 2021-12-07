# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

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
end
