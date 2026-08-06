class ProviderOrdersController < ApplicationController
  before_action :set_provider_order, only: %i[show receive]

  def index
    @provider_orders = ProviderOrder.includes(:provider).order(created_at: :desc)
  end

  def show
  end

  def receive
    received = false

    @provider_order.with_lock do
      unless @provider_order.delivered?
        @provider_order.update!(delivered: true)
        InventoryStockAddedEvent.create!(@provider_order)
        received = true
      end
    end

    notice = received ? "Provider order was marked as received." : "Provider order was already received."
    redirect_to @provider_order, notice: notice
  end

  private

  def set_provider_order
    @provider_order = ProviderOrder.includes(:provider).find(params[:id])
  end
end
