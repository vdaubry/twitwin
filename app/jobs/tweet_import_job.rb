class TweetImportJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, :dead => false

  def tweets(lang:)
    keywords = Keyword.new(lang: lang).texts
    api = TwitterClient::Api.new

    result = keywords.map do |keyword|
      api.tweets(text: keyword, count: 200, options: {language: lang})
          .reject {|tweet| tweet.retweeted? }
          .reject {|tweet| tweet.image_url.nil? }
    end.flatten

    result.uniq {|res| res.id}
  end

  def perform(lang)
    logger.info "TweetImportJob : start importing for language : #{lang}"

    new_tweets = tweets(lang: lang)
    new_tweets.each do |api_tweet|
      db_tweet = Tweet.create(twitter_id: api_tweet.id,
                  text: api_tweet.text,
                  tweeted_at: api_tweet.created_at,
                  author_image_url: api_tweet.author_image_url,
                  image_url: api_tweet.image_url,
                  link: api_tweet.link,
                  language: lang,
                  username: api_tweet.username,
                  #specify created_at so we can validate uniqueness of tweet per day before we create it
                  created_at: DateTime.now)
      logger.error db_tweet.errors.full_messages if db_tweet.errors.present?
    end
  end
end
