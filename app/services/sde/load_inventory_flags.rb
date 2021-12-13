# frozen_string_literal: true

module SDE
  class LoadInventoryFlags < YAMLLoader
    protected

    self.record_class = InventoryFlag

    def load_records
      flags = yaml(source_path)
      flags.each do |flag|
        record(
          flag,
          flag['flagID'],
          %w[flag_name flag_text order_id],
          rename: { 'flag_name' => 'name', 'flag_text' => 'text', 'order_id' => 'order' }
        )
      end
    end
  end
end
