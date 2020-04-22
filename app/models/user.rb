class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  include DeviseTokenAuth::Concerns::User

  has_many :projects, dependent: :destroy
end
