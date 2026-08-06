require "securerandom"

class InventoryStockAddedEvent
  def self.create!(provider_order)
    event_id = SecureRandom.uuid

    OutboxEvent.create!(
      event_id: event_id,
      event_type: "inventory.stock_added",
      aggregate_type: "ProviderOrder",
      aggregate_id: provider_order.id,
      payload: {
        event_id: event_id,
        event_type: "inventory.stock_added",
        event_version: 1,
        source: "kafky_providers",
        occurred_at: Time.current.iso8601,
        data: {
          provider_order_id: provider_order.id,
          sku: provider_order.product_sku,
          quantity: provider_order.purchase_quantity
        }
      }
    )
  end
end
