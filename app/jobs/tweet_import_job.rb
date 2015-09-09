class TweetImportJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, :dead => false

  def tweets(lang:)
    return @tweets if @tweets
    keywords = Keyword.new(lang: lang).texts
    api = TwitterClient::Api.new

    result = keywords.map do |keyword|
      api.tweets(text: keyword, count: 200, options: {language: lang}).reject {|tweet| tweet.retweeted? }
    end.flatten

    @tweets = result.uniq {|res| res.id}
  end

  def perform(lang)
    new_tweets = tweets(lang: lang)
    new_tweets.each do |api_tweet|
      db_tweet = Tweet.create(tweet_id: api_tweet.id,
                  text: api_tweet.text,
                  tweeted_at: api_tweet.created_at,
                  author_image_url: api_tweet.author_image_url,
                  image_url: api_tweet.image_url,
                  link: api_tweet.link,
                  language: lang,
                  username: api_tweet.username,
                  #specify created_at so we can validate uniqueness of tweet per day before we create it
                  created_at: DateTime.now)
      Rails.logger.debug db_tweet.errors.full_messages if db_tweet.errors.present?
    end
  end
end
