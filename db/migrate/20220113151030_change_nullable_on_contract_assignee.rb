# frozen_string_literal: true

class ChangeNullableOnContractAssignee < ActiveRecord::Migration[6.1]
  def up
    change_column :contracts, :assignee_id, :bigint, null: true
    change_column :contracts, :assignee_type, :text, null: true
  end
end
