class ProviderOrder < ApplicationRecord
  belongs_to :provider

  validates :product_sku, :product_desc, :source_event_id, presence: true
  validates :purchase_quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :source_event_id, uniqueness: true
end
