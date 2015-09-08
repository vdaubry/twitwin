TwitterTweet = Struct.new(:tweet_id, :text, :tweeted_at)

FactoryGirl.define do
  factory :tweet_dao, class: TwitterClient::TweetDao do
    tweet_id ||= 1
    text ||= "text"
    tweeted_at ||= Date.parse("01/01/2011")

    initialize_with { TwitterTweet.new(tweet_id, text, tweeted_at) }
  end
end