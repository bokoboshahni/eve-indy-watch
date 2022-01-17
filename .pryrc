# frozen_string_literal: true

Pry.config.prompt = Pry::Prompt[:rails]
Pry.config.pager = false

def app_config
  @app_config ||= Rails.application.config.x.app
end

def esi_config
  @esi_config ||= Rails.application.config.x.esi
end

def esi_client
  @esi_client ||= ESI::Client.new(user_agent: app_config.user_agent)
end

def esi_authorize!(authorization)
  authorization.refresh_token!
  { Authorization: "Bearer #{authorization.access_token}" }
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
