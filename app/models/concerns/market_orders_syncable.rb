module MarketOrdersSyncable
  extend ActiveSupport::Concern

  included do
    has_many :market_order_batches, class_name: 'MarketOrder::Batch', as: :location
  end

  def esi_market_orders_expired?
    return true unless esi_market_orders_expires_at

    esi_market_orders_expires_at <= Time.zone.now
  end

  def create_market_order_batch_async
    MarketOrder::CreateBatchWorker.perform_async(self.class.name, id)
  end
end
