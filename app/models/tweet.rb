class Tweet < ActiveRecord::Base
  scope :recent, -> { order("tweeted_at DESC") }

  validates :tweet_id, :text, :author_image_url, :tweeted_at, presence: true
  validates :tweet_id, uniqueness: true
  validate  :unique_text_by_day

  def unique_text_by_day
    if self.created_at && Tweet.where(text: self.text)
            .where("date(created_at) = date('#{self.created_at.strftime("%Y-%m-%d")}')")
            .count>0
      errors.add(:text, "already exist for this day")
    end
  end
end