TwitterTweet = Struct.new(:id, :twitter_id, :text, :tweeted_at, :image_url, :created_at, :author_image_url, :link, :username)

FactoryGirl.define do
  factory :tweet_dao, class: TwitterClient::TweetDto do
    id ||= 1
    twitter_id ||= 1
    text ||= "text"
    tweeted_at ||= Date.parse("01/01/2011")
    image_url ||= "http://www.foo.bar/img.png"
    created_at ||= DateTime.now
    author_image_url ||= "http://www.foo.bar/img.png"
    link ||= "http://www.foo.bar"
    username ||= "foobar"

    initialize_with { TwitterTweet.new(id, twitter_id, text, tweeted_at, image_url, created_at, author_image_url, link, username) }
  end
end