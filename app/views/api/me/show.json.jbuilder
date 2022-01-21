# frozen_string_literal: true

json.call(current_resource_owner, :admin, :character_id, :created_at, :roles, :id, :updated_at)

json.character do
  json.call(
    current_resource_owner.character,
    :alliance_id, :corporation_id, :created_at, :esi_expires_at, :esi_last_modified_at, :id, :name,
    :portrait_url_64, :portrait_url_128, :portrait_url_256, :portrait_url_512, :updated_at # rubocop:disable Naming/VariableNumber
  )

  if current_resource_owner.character.alliance.present?
    json.alliance do
      json.call(
        current_resource_owner.character.alliance,
        :created_at, :esi_expires_at, :esi_last_modified_at, :icon_url_128, :icon_url_64, :name, :ticker, :updated_at # rubocop:disable Naming/VariableNumber
      )
    end
  end

  json.corporation do
    json.call(
      current_resource_owner.character.corporation,
      :alliance_id, :created_at, :esi_expires_at, :esi_last_modified_at, :icon_url_128, :icon_url_256, :icon_url_64, :name, # rubocop:disable Naming/VariableNumber
      :ticker, :updated_at, :url
    )

    json.npc current_resource_owner.character.corporation.npc.present?
  end
end
