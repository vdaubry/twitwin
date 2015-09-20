module TwitterClient
  class Api
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

    def follow(username:)
      return if Rails.env.test?
      Rails.logger.info "Follow user #{username}"
      rate_limit do
        user = client.user(username)
        client.follow(user.id)
      end
    end

    def retweet(status_id:)
      return if Rails.env.test?
      Rails.logger.info "Follow status #{status_id}"
      rate_limit do
        client.retweet([status_id])
      end
    end

    def direct_messages(options: {})
      convert_to_dao do
        begin
          client.direct_messages(options)
        rescue Twitter::Error::Unauthorized => e
          raise TwitterClient::CredentialsExpired.new(e.message)
        end
      end
    end

    private
    attr_reader :client

    def convert_to_dao
      yield.map {|tweet| TwitterClient::TweetDto.new(tweet: tweet)}
    end

    def rate_limit
      begin
        yield
      rescue Twitter::Error::TooManyRequests => error
        wait_time = error.rate_limit.reset_in.try(:+, 1)
        raise TwitterClient::TooManyRequests.new(wait_time)
      rescue Twitter::Error::Forbidden => error
        Rails.logger.error error.message
      end
    end
  end

  class TooManyRequests < StandardError
    attr_reader :wait_time
    def initialize(wait_time)
      @wait_time = wait_time
    end
  end
  class CredentialsExpired < StandardError; end
end