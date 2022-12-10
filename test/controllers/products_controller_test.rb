# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test 'should show products' do
    get product_url(@product), as: :json
    assert_response :success

    json_response = JSON.parse(response.body)

    assert_equal @product.title, json_response.dig('data', 'attributes', 'title')
    assert_equal @product.user.id.to_s, json_response.dig('data', 'relationships', 'user', 'data', 'id')
    assert_equal @product.user.email, json_response.dig('included', 0, 'attributes', 'email')
  end

  test 'shohuld show products list' do
    get products_url, as: :json
    assert_response :success
  end

  test 'should create products ' do
    assert_difference('Product.count', 1) do
      post products_url, params: { product: { title: 'redmi', price: 12_000, published: true } },
                         headers: { Authorization: JsonWebToken.encode(user_id: @product.user_id) },
                         as: :json
    end
    assert_response :created
  end

  test 'should forhibit create product ' do
    assert_no_difference('Product.count') do
      post products_url, params: { product: { title: 'redmi', price: 14_000, published: true } }, as: :json
    end
    assert_response :forbidden
  end

  test 'should update products' do
    patch product_url(@product), params: { product: { title: 'redmi not9 pro' } },
                                 headers: { Authorization: JsonWebToken.encode(user_id: @product.user_id) },
                                 as: :json

    assert_response :success
  end

  test 'shohuld forhibit update product ' do
    patch product_url(@product), params: { product: { title: 'redmi pro max' } },
                                 as: :json

    assert_response :forbidden
  end

  test 'shoud destroy product' do
    assert_difference('Product.count', -1) do
      delete product_url(@product), headers: { Authorization: JsonWebToken.encode(user_id: @product.user_id) },
                                    as: :json
    end
    assert_response :no_content
  end
end
