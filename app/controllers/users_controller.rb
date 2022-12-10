# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :check_owner, only: %i[update destroy]
  def show
    options = { include: [:products] }
    render json: UserSerializer.new(@user, options).serializable_hash
  end

  def index
    @users = User.all
    render json: UserSerializer.new(@users).serializable_hash
  end

  def create
    user = User.create(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors
    end
  end

  def destroy
    @user.destroy
    head 204
  end

  private

  def user_params
    params.permit(:name, :email, :password_digest)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def check_owner
    head :forbidden unless @user.id == current_user&.id
  end
end
