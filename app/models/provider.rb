class Provider < ApplicationRecord
  validates :name, :email, presence: true
  validates :email, uniqueness: true
end
