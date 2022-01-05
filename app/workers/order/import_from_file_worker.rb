class Order < StatisticsRecord
  class ImportFromFileWorker < ApplicationWorker
    sidekiq_options lock: :until_executed

    def perform(file)
      Order::ImportFromFile.call(file)
    end
  end
end
