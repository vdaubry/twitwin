module TwitterClient
  class Api
    attr_reader :client
    def initialize(access_token: nil, access_token_secret: nil)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_OAUTH_API_ID"]
        config.consumer_secret     = ENV["TWITTER_OAUTH_API_SECRET"]
        config.access_token        = access_token if access_token
        config.access_token_secret = access_token_secret if access_token_secret
      end
    end
    
    def tweets(text:, count:, options: {})
      convert_to_dao do
        client.search(text, options).take(count)
      end
    end

    def follow(user_id:)
      return if Rails.env.test?
      user = client.user(user_id)
      client.follow(user.id)
    end

    def retweet(status_id:)
      return if Rails.env.test?
      client.retweet([status_id])
    end

    def direct_messages(options: {})
      convert_to_dao do
        client.direct_messages(options)
      end
    end

    private

    def convert_to_dao
      yield.map {|tweet| TwitterClient::TweetDao.new(tweet: tweet)}
    end
  end
end