class Provider < ApplicationRecord
  has_many :provider_orders, dependent: :restrict_with_exception

  validates :name, :email, presence: true
  validates :email, uniqueness: true
end
