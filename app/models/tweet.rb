class Tweet < ActiveRecord::Base
  scope :recent, -> { order("created_at DESC") } 

  validates :tweet_id, :text, :author_image_url, :tweeted_at, presence: true
  validates :tweet_id, uniqueness: true
  validate  :unique_text_by_day

  def unique_text_by_day
    if self.created_at && Tweet.where(text: self.text)
            .where("date_trunc('day', created_at) = '#{self.created_at.beginning_of_day.strftime("%Y-%m-%d %H:%M:%S")}'")
            .count>0
      errors.add(:text, "already exist for this day")
    end
  end
end