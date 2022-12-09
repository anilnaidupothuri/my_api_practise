class Product < ApplicationRecord
  validates :price, numericality: {greater_than_or_equal_to: 0}
  validates :title, :user_id, :price, presence: true
  belongs_to :user
end
