class User < ActiveRecord::Base
  
  has_many :authentication_providers, dependent: :destroy
  has_many :tweets_users
  has_many :tweets, through: :tweets_users, dependent: :destroy

  validates :email, uniqueness: true, allow_nil: true
  validates_with Validators::EmailValidator, on: :update
end