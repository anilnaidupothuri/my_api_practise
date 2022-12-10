# frozen_string_literal: true

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test 'should have a positive price ' do
    product = products(:one)
    product.price = -1
    assert_not product.valid?
  end

  test 'should filter products by title' do
    assert_equal 2, Product.filter_by_title('My').count
  end

  test 'should filter products by price' do
    assert_equal [products(:three)], Product.above_or_equal_to_price(200)
  end

  test 'should filter products by price lower' do
    assert_equal [products(:one), products(:two)], Product.max_price(200)
  end
end
