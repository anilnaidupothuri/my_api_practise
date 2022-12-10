# frozen_string_literal: true

class Placement < ApplicationRecord
  after_create :decrement_product_quantity!
  belongs_to :order
  belongs_to :product

  def decrement_product_quantity!
    product.decrement!(:qunatity, quantity)
  end
end
