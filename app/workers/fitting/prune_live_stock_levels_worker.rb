# frozen_string_literal: true

class Fitting < ApplicationRecord
  class PruneLiveStockLevelsWorker < ApplicationWorker
    def perform
      FittingStockLevel.where(interval: 'live').where('time <= ?', app_config.fitting_stock_level_expiry.minutes.ago).destroy_all
    end
  end
end
