# frozen_string_literal: true

class AddESIAuthorizationToStructures < ActiveRecord::Migration[6.1]
  def change
    add_reference :structures, :esi_authorization, index: true, foreign_key: true
  end
end
