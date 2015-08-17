class Tweet < ActiveRecord:Base
  scope :recent, -> { order("created_at DESC") } 

  validates :tweet_id, :text, :author_image_url, presence: true
end