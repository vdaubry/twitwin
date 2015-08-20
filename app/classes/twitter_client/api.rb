module TwitterClient
  class Api
    def initialize
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_OAUTH_API_ID"]
        config.consumer_secret     = ENV["TWITTER_OAUTH_API_SECRET"]
      end
    end
    
    def tweets(text:, options: {})
      @client.search(text, options)
    end
  end
end