# frozen_string_literal: true

class Product < ApplicationRecord
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :title, :user_id, :price, presence: true
  belongs_to :user

  has_many :placements
  has_many :orders, through: :placements
  scope :filter_by_title, ->(title) { where('lower(title) LIKE ?', "%#{title.downcase}%") }
  scope :above_or_equal_to_price, ->(price) { where('price >= ?', price) }
  scope :max_price, ->(price) { where('price <= ?', price) }

  def self.search(params)
    products = []
    products = Product.all
    products = max_price(params[:max_price]) if params[:max_price]
    products = above_or_equal_to_price(params[:min_price]) if params[:min_price]
    products = filter_by_title(params[:title]) if params[:title]
    products
  end
end
