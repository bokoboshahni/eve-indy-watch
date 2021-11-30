# frozen_string_literal: true

require 'csv'

module SDE
  class LoadTypes < YAMLLoader
    protected

    self.record_class = Type

    def load_records
      packaged_volumes = CSV.read(Rails.root.join('db/packaged_volumes.csv'), headers: true)
      yaml(source_path).each do |(id, type)|
        record(
          type,
          id,
          %w[description name published portion_size published volume group_id market_group_id],
          optional: %w[packaged_volume portion_size published volume market_group_id],
          extra: {
            packaged_volume: packaged_volumes.find { |r| r['typeID'].to_i == id }&.[]('volume')
          }
        )
      end
    end
  end
end
