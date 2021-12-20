# frozen_string_literal: true

require 'csv'

module SDE
  class LoadBlueprints < YAMLLoader
    protected

    def load_records
      type_updates = []
      activities = []
      materials = []
      products = []
      skills = []

      yaml(source_path).each do |(blueprint_type_id, blueprint)|
        blueprint['activities'].each_with_object([]) do |(activity_name, activity)|
          activity_key = { blueprint_type_id: blueprint_type_id, activity: activity_name }

          Array(activity['materials']).each do |m|
            materials << { material_type_id: m['type_id'], quantity: m['quantity'] }.merge(activity_key)
          end

          Array(activity['products']).each do |p|
            products << { product_type_id: p['type_id'], quantity: p['quantity'] }.merge(activity_key)
          end

          Array(activity['skills']).each do |s|
            skills << { skill_type_id: s['type_id'], level: s['level'] }.merge(activity_key)
          end

          activities << { time: activity['time'] }.merge(activity_key)
        end

        type_updates << {
          id: blueprint_type_id,
          max_production_limit: blueprint['max_production_limit'],
        }
      end

      Type.transaction do
        Type.import(
          type_updates,
          on_duplicate_key_update: {
            conflict_target: %i[id],
            columns: %i[max_production_limit]
          }
        )

        BlueprintActivity.import(
          activities,
          on_duplicate_key_update: {
            conflict_target: %i[blueprint_type_id activity],
            columns: :all
          }
        )

        BlueprintMaterial.import(
          materials,
          on_duplicate_key_update: {
            conflict_target: %i[blueprint_type_id activity material_type_id],
            columns: :all
          }
        )

        BlueprintProduct.import(
          products,
          on_duplicate_key_update: {
            conflict_target: %i[blueprint_type_id activity product_type_id],
            columns: :all
          }
        )

        BlueprintSkill.import(
          skills.uniq,
          on_duplicate_key_update: {
            conflict_target: %i[blueprint_type_id activity skill_type_id],
            columns: :all
          }
        )
      end
    end

    def import_records
    end
  end
end
