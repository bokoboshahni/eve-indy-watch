# frozen_string_literal: true

class CreateNotificationSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :slack_webhooks do |t|
      t.references :owner, polymorphic: true

      t.text :channel, null: false
      t.text :icon_emoji
      t.text :name, null: false
      t.text :url_ciphertext, null: false
      t.timestamps null: false

      t.index %i[owner_id owner_type name], unique: true, name: :index_unique_slack_webhooks_by_owner
    end

    create_table :notification_subscriptions do |t|
      t.references :subscriber, polymorphic: true, null: false
      t.references :slack_webhook, foreign_key: true

      t.text :notification_type, null: false
      t.timestamps null: false

      t.index %i[subscriber_id subscriber_type notification_type], unique: true, name: :index_unique_notification_subscriptions
    end
  end
end
