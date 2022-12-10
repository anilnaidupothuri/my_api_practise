# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, uniqueness: true

  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_secure_password
end
