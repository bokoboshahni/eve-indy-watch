class MarketOrderSnapshot < ApplicationRecord
  class PruneWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(before)
      time =
        case before
        when 'today'
          Time.zone.now.beginning_of_day
        else
          DateTime.parse(before)
        end

      MarketOrderSnapshot.prune(time)
    end
  end
end
