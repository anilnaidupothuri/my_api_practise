require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @order = orders(:one)
    @order_params = { order: { product_ids: [products(:one).id, products(:two).id], total:2 }}
  end 

  test 'should forbid orders for unlogged' do 
     get orders_url, as: :json 
     assert_response :forbidden
  end

  test 'should get orders ' do 
     get orders_url,headers: {Authorization: JsonWebToken.encode(user_id: @order.user_id)}, as: :json

      assert_response :success

      json_response = JSON.parse(response.body)
      assert_equal @order.user.orders.count, json_response['data'].count 
  end

  test 'should show order' do
     get order_url(@order), headers: {Authorizaton: JsonWebToken.encode(user_id: @order.user_id)},
                             as: :json
      

     assert_response :success
     json_response = JSON.parse(response.body)
     product_attributes = json_response['included'][0]['attributes']
     assert_equal @order.products.first.title, product_attributes['title']
  end 

  test 'should forbid users to create orders with out logged in' do 
    assert_no_difference('Order.count') do 
      post orders_url, params: @order_params, as: :json 
    end 
    assert_response :forbidden
  end 

  test 'should create orders' do 
    assert_difference('Order.count', 1) do 
      post orders_url, params: @order_params,
                       headers: {Authorization: JsonWebToken.encode(user_id: @order.user_id)},
                       as: :json
      end
      assert_response :success
    end



end
