require "test_helper"

class ProviderOrdersRealtimeTest < ActionDispatch::IntegrationTest
  test "renders the provider order stream and list container" do
    provider = Provider.create!(name: "Acme Supplies", email: "orders@acme.test")
    provider_order = ProviderOrder.create!(
      provider: provider,
      product_sku: "KEYBOARD-1",
      product_desc: "Keyboard",
      purchase_quantity: 7,
      source_event_id: "low-stock-event-1"
    )

    get provider_orders_path

    assert_response :success
    assert_select "turbo-cable-stream-source[signed-stream-name]", count: 1
    assert_select "#provider_orders"
    assert_select "tr#provider_order_#{provider_order.id}", text: /KEYBOARD-1/
  end
end
