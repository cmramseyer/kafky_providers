class ProviderOrderBroadcaster
  STREAM_NAME = "provider_orders"

  def self.created(provider_order)
    Turbo::StreamsChannel.broadcast_replace_to(
      STREAM_NAME,
      target: "provider_orders",
      partial: "provider_orders/provider_order_list",
      locals: {
        provider_orders: ProviderOrder.includes(:provider).order(created_at: :desc),
        highlight_provider_order_id: provider_order.id
      }
    )
  end
end
