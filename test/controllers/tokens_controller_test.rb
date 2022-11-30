# frozen_string_literal: true

require 'test_helper'

class TokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end
  test 'should generate jwt tokens' do
    post tokens_url, params: { user: { email: @user.email, password_digest: 'one123' } }, as: :json
    assert_response :success

    json_response = JWT.parse(response.body)
    assert_not_nil json_response['token']
  end

  test 'shoud not generate jwt token' do
    post tokens_url, params: { user: { email: @user.email, password_digest: 'hvcsdyv' } }, as: :json
    assert_response :unauthorized
  end
end
