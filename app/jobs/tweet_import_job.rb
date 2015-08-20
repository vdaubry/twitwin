class TweetImportJob
  include Sidekiq::Worker

  def perform
    api = TwitterClient::Api.new
    tweets = api.tweets(text: "'rt to win'", options: {language: "en"})#, since: 1.day.ago.strftime("%Y-%m-%d")})
    tweets = tweets.take(100)
    tweets.reject! {|tweet| tweet.retweeted? }
    if tweets.present?
      tweets.map do |tweet|
        tweet = Tweet.create(tweet_id: tweet.id,
                      text: tweet.text,
                      tweeted_at: tweet.created_at,
                      author_image_url: tweet.user.profile_image_uri.to_s,
                      image_url: tweet_image_url(tweet),
                      link: link(tweet),
                      language: "en",
                      created_at: DateTime.now)
        Rails.logger.debug tweet.errors.full_messages if tweet.errors.present?
      end
    end
  end

  def tweet_image_url(tweet)
    tweet.media.select {|tweet| tweet.is_a? Twitter::Media::Photo }
               .map {|tweet| tweet.media_url.to_s }
               .first
  end

  def link(tweet)
    return if tweet.urls.blank?
    tweet.urls.first.to_s
  end
end
