class TweetImportJob
  include Sidekiq::Worker

  def perform
    api = TwitterClient::Api.new
    tweets = api.tweets(text: "'rt pour gagner'", options: {language: "fr"})#, since: 1.day.ago.strftime("%Y-%m-%d")})
    tweets = tweets.take(200)
    tweets.reject! {|tweet| tweet.retweeted? }
    if tweets.present?
      tweets.map do |api_tweet|
        db_tweet = Tweet.create(tweet_id: api_tweet.id,
                      text: api_tweet.text,
                      tweeted_at: api_tweet.created_at,
                      author_image_url: api_tweet.user.profile_image_uri.to_s,
                      image_url: tweet_image_url(api_tweet),
                      link: link(api_tweet),
                      language: api_tweet.lang,
                      username: TweetExtensions::Meta.new(text: api_tweet.text,
                                                          author: api_tweet.user.screen_name).username,
                      created_at: DateTime.now)
        Rails.logger.debug db_tweet.errors.full_messages if db_tweet.errors.present?
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
