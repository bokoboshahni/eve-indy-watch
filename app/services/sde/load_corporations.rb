# frozen_string_literal: true

module SDE
  class LoadCorporations < YAMLLoader
    protected

    self.record_class = Corporation

    def load_records
      yaml(source_path).each do |(id, corporation)|
        record(
          corporation,
          id,
          %w[name ticker_name],
          rename: { 'ticker_name' => 'ticker' },
          extra: { 'npc' => true }
        )
      end
    end
  end
end
