# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end
  test 'should create user' do
    assert_difference('User.count') do
      post users_url, params: { user: { name: 'anil', email: 'anil@gmail.com', password: '123456' } }, as: :json
    end
    assert_responce :success
  end

  test 'should not create user with taken email' do
    assert_no_difference('User.count') do
      post users_url, params: { user: { name: 'test', email: @user.email, password: '12345' } }, as: :json
    end
    assert_response :unprocessable_entity
  end

  test 'should show user' do
    get user_url(@user), as: :json

    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal @user.email, json_response['email']
  end

  test 'should show all users' do
    get users_url, as: :json
    assert_response :success
  end

  test 'should update user' do
    patch user_url(@user), params: { user: { name: 'test' } },
                          headers: {Authorization:JsonWebToken.encode(user_id: @user.id)}, as: :json
    assert_response :success
  end

  test 'shoud forbid update user' do
    patch user_url(@user), params: { user: {name: "test", mail:@user.email}}
    assert_response :forbidden
  end

  test 'should delete user' do
    assert_difference('User.count', -1) do
      delete user_url(@user), headers:{Authorization: JsonWebToken.encode(user_id: @user.id)},as: :json
    end
    assert_response :no_content
  end

  test 'should forbid delete user' do 
    assert_no_difference('User.count') do 
      delete user_url(@user), as: :json
    end
    assert_response :forbidden
  end

  test 'destroy user should destroy linked product' do 
    assert_difference('Product.count',-1) do 
      users(:one).destroy
    end 
  end 

end
