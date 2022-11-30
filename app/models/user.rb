# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, uniqueness: true
  has_secure_password
end
