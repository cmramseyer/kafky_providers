require "test_helper"

class InventoryEventsConsumerTest < ActiveSupport::TestCase
  include Turbo::Broadcastable::TestHelper

  test "creates a provider order and broadcasts the highlighted list" do
    Provider.create!(name: "Acme Supplies", email: "orders@acme.test")

    streams = capture_turbo_stream_broadcasts("provider_orders") do
      process_message
    end

    provider_order = ProviderOrder.find_by!(source_event_id: "low-stock-event-1")

    assert_equal "KEYBOARD-1", provider_order.product_sku
    assert_equal 7, provider_order.purchase_quantity
    assert_equal "replace", streams.first["action"]
    assert_equal "provider_orders", streams.first["target"]
    assert_includes streams.first.at("template").inner_html, "provider-order-created"
    assert_includes streams.first.at("template").inner_html, "KEYBOARD-1"
  end

  test "does not broadcast when a retried low-stock event finds the provider order" do
    provider = Provider.create!(name: "Acme Supplies", email: "orders@acme.test")
    ProviderOrder.create!(
      provider: provider,
      product_sku: "KEYBOARD-1",
      product_desc: "Keyboard",
      purchase_quantity: 7,
      source_event_id: "low-stock-event-1"
    )

    assert_no_turbo_stream_broadcasts "provider_orders" do
      process_message
    end
  end

  private

  def process_message
    payload = {
      event_id: "low-stock-event-1",
      event_type: "inventory.low_stock",
      event_version: 1,
      source: "kafky_storage",
      data: {
        product: {
          sku: "KEYBOARD-1",
          item_desc: "Keyboard",
          available_quantity: 3,
          reorder_point: 5
        }
      }
    }
    message = Struct.new(:payload).new(payload.to_json)

    InventoryEventsConsumer.new.send(:process_message, message)
  end
end
