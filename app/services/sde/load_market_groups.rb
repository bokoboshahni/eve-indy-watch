# frozen_string_literal: true

module SDE
  class LoadMarketGroups < YAMLLoader
    protected

    self.record_class = MarketGroup

    def load_records
      groups = yaml(source_path)
      groups.each do |(id, group)|
        record(
          group,
          id,
          %w[description name parent_group_id published],
          optional: %w[description parent_id],
          rename: { 'parent_group_id' => 'parent_id' }
        )
      end
    end

    def after_import
      MarketGroup.build_ancestry_from_parent_ids!
      MarketGroup.check_ancestry_integrity!
    end
  end
end
