# frozen_string_literal: true

Pry.config.prompt = Pry::Prompt[:rails]
Pry.config.pager = false

def app_config
  @app_config ||= Rails.application.config.x.app
end

def esi
  @esi ||= ESI::Client.new(user_agent: app_config.user_agent)
end

def markets_reader
  @markets_reader ||= Kredis.redis(config: :markets_reader)
end

def markets_writer
  @markets_writer ||= Kredis.redis(config: :markets_writer)
end

def orders_reader
  @orders_reader ||= Kredis.redis(config: :orders_reader)
end

def orders_writer
  @orders_writer ||= Kredis.redis(config: :orders_writer)
end

def main_alliance
  Alliance.find(app_config.main_alliance_id)
end
