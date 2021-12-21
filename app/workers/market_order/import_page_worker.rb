class MarketOrder < ApplicationRecord
  class ImportPageWorker < ApplicationWorker
    def perform(batch_id, page)
      page = MarketOrder::BatchPage.find([batch_id, page])
      location = page.location

      order_location_ids = page.import!

      return unless order_location_ids&.any?

      time = Time.zone.now
      order_location_ids -= Station.where(id: order_location_ids).pluck(:id)
      order_location_ids -= Structure.where(id: order_location_ids).where('esi_expires_at >= ?', time).pluck(:id)

      order_location_args = order_location_ids.to_a.map { |id| [id, location.esi_authorization_id] }
      ResolveAndSyncLocationWorker.perform_bulk(order_location_args)
    end
  end
end
