module TwitterClient
  class Api
    attr_reader :client
    def initialize
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_OAUTH_API_ID"]
        config.consumer_secret     = ENV["TWITTER_OAUTH_API_SECRET"]
      end
    end
    
    def tweets(text:, options: {})
      client.search(text, options)
    end

    def follow(user_id:)
      client.follow(user_id)
    end

    def retweet(status_id:)
      client.retweet([status_id])
    end
  end
end