require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should create user' do 
    assert_difference('User.count') do 
      post users_url, params:{ user: {name:"anil", email:"anil@gmail.com", password:"123456"}}, as: :json 
      byebug
    end 
    assert_responce :success 
  end

end
