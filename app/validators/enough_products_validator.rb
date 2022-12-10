# frozen_string_literal: true

class EnoughProductsValidator < ActiveModel::Validator
  def validate(record)
    record.placements.each do |placement|
      product = placement.product
      if placement.quantity > product.quantity
        record.erros[product.title.to_s] << "Is out of stock , just #{product.quantity} ara avaible"
      end
    end
  end
end
