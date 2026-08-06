require "json"

class InventoryEventsConsumer < ApplicationConsumer
  class ProviderUnavailableError < StandardError; end

  def consume
    messages.each do |message|
      process_message(message)
    end
  end

  private

  def process_message(message)
    payload = message.payload.is_a?(String) ? JSON.parse(message.payload) : message.payload
    validate_low_stock_event!(payload)

    product = payload.fetch("data").fetch("product")
    reorder_point = product.fetch("reorder_point").to_i

    # TODO: Define replenishment behavior for products without a reorder point.
    return if reorder_point.zero?

    ProviderOrder.find_or_create_by!(source_event_id: payload.fetch("event_id")) do |provider_order|
      provider_order.provider = random_provider!
      provider_order.product_sku = product.fetch("sku")
      provider_order.product_desc = product.fetch("item_desc")
      provider_order.purchase_quantity = (2 * reorder_point) - product.fetch("available_quantity").to_i
    end
  end

  def random_provider!
    Provider.order(Arel.sql("RANDOM()")).first || raise(ProviderUnavailableError, "No provider available")
  end

  def validate_low_stock_event!(payload)
    return if payload.fetch("event_type") == "inventory.low_stock" &&
              payload.fetch("source") == "kafky_storage" &&
              payload.fetch("event_version").to_i == 1

    raise ArgumentError,
          "Unsupported inventory.low_stock source=#{payload.fetch("source").inspect} event_version=#{payload.fetch("event_version").inspect}"
  end
end
