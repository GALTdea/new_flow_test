class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  normalizes :email, with: ->(email) { email.to_s.strip.downcase }
end
