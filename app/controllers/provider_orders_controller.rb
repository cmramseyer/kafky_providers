class ProviderOrdersController < ApplicationController
  def index
    @provider_orders = ProviderOrder.includes(:provider).order(created_at: :desc)
  end

  def show
    @provider_order = ProviderOrder.includes(:provider).find(params[:id])
  end
end
