class TweetsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :tweet
  
  validates :tweet_id, :uniqueness => { :scope => :user_id }
end