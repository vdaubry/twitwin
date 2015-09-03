class TweetsPresenter
  def initialize
  end

  def username(tweet:)
    tweet.username.gsub("@","")
  end

  def link(tweet:)
    "https://twitter.com/#{username(tweet: tweet)}/statuses/#{tweet.tweet_id}"
  end
end