# frozen_string_literal: true

class TokensController < ApplicationController
  def create
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password_digest])
      render json: {
        token: JsonWebToken.encode(user_id: @user.id),
        email: @user.email
      }
    else
      head :unauthorized
    end
  end
end
