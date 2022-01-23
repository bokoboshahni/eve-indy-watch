# frozen_string_literal: true

class Market < ApplicationRecord
  class ArchiveTypeStatistics < ApplicationService
    def initialize(market_id, time)
      super

      @market_id = market_id
      @time = time
    end

    def call # rubocop:disable MMetrics/AbcSize, Metrics/MethodLength
      return unless history_uploads_enabled?

      type_stats_keys = markets_reader.scan_each(match: "#{market_key}.*.stats").to_a
      type_stats = type_stats_keys.each_slice((type_stats_keys.size / 100.0).round).to_a.each_with_object([]) do |keys, a|
        a.push(*markets_reader.mget(*keys).map! { |j| Oj.load(j).deep_stringify_keys! })
      end

      types_file = "#{market_dir}/#{time.to_s(:number)}.json"
      measure_debug(
        "Wrote #{type_stats.count} type(s) to #{types_file} for #{log_name} at #{log_time}",
        metric: "#{METRIC_NAME}/write_file"
      ) do
        FileUtils.mkdir_p(market_dir)
        File.write(types_file, Oj.dump(type_stats))
      end

      types_file_bz2 = "#{types_file}.bz2"
      measure_debug(
        "Compressed #{types_file} to #{types_file_bz2} for #{log_name} at #{log_time}",
        metric: "#{METRIC_NAME}/compress_file"
      ) do
        cmd.run("bzip2 -q #{types_file}", only_output_on_error: true)
      end

      history_path = "markets/#{market_id}/#{time.year}/#{time.month}/#{time.day}/#{File.basename(types_file_bz2)}"
      measure_debug(
        "Uploaded #{types_file_bz2} to #{history_path} for #{log_name} at #{log_time}",
        metric: "#{METRIC_NAME}/upload_file"
      ) do
        history_bucket.put_object(body: File.open(types_file_bz2.to_s), key: history_path)
      end

      FileUtils.rm_rf(types_file_bz2)
    end

    private

    METRIC_NAME = 'market/archive_type_statistics'

    attr_reader :market_id, :time

    def market_dir
      Rails.root.join("tmp/markets/#{market_id}")
    end

    def market_key
      @market_key ||= "markets.#{market_id}.#{time_key}.types"
    end

    def time_key
      time.to_s(:number)
    end

    def log_name
      market_id
    end

    def log_time
      time.to_s(:db)
    end
  end
end
