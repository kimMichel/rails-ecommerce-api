class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
end
