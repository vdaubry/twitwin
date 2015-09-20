class Tweet < ActiveRecord::Base
  scope :recent, -> { order("tweeted_at DESC") }

  has_many :tweets_users
  has_many :users, through: :tweets_users, dependent: :destroy

  validates :twitter_id, :text, :author_image_url, :tweeted_at, presence: true
  validates :twitter_id, uniqueness: true
  validate  :unique_text_by_day
  validate :unique_image_url_by_month

  def unique_text_by_day
    if self.created_at && Tweet.where(text: self.text)
            .where("date(created_at) = date('#{self.created_at.strftime("%Y-%m-%d")}')")
            .count>0
      errors.add(:text, "already exist for this day")
    end
  end

  def unique_image_url_by_month
    if self.created_at && Tweet.where(image_url: self.image_url)
                              .where("created_at > ?", self.created_at-1.month)
                              .count>0
      errors.add(:image, "already exist for this month")
    end
  end
end