module TwitterClient
  class TooManyRequests < StandardError; end
  class CredentialsExpired < StandardError; end

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
      Rails.logger.debug "Follow user #{username}"
      rate_limit do
        user = client.user(username)
        client.follow(user.id)
      end
    end

    def retweet(status_id:)
      return if Rails.env.test?
      Rails.logger.debug "Follow status #{status_id}"
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
      yield.map {|tweet| TwitterClient::TweetDao.new(tweet: tweet)}
    end

    def rate_limit
      number_of_retry = 0
      begin
        yield
      rescue Twitter::Error::TooManyRequests => error
        wait_time = error.rate_limit.reset_in.try(:+, 1)
        Rails.logger.debug("User was rate limited, waiting #{wait_time} sec")
        sleep wait_time
        number_of_retry+=1
        if number_of_retry < 3
          retry
        else
          raise TwitterClient::TooManyRequests(error.message)
        end
      rescue StandardError => error
        Rails.logger.debug error.message
      end
    end
  end
end