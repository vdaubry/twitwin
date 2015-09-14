class ParticipateJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, :dead => false

  def perform(tweet_id, user_id)
    tweet = Tweet.find(tweet_id)
    auth_provider = User.find(user_id).authentication_providers.first
    api = TwitterClient::Api.new(access_token: auth_provider.token, access_token_secret: auth_provider.secret)

    api.follow(username: tweet.username)
    api.retweet(status_id: tweet.twitter_id)
  end


  sidekiq_retry_in do |count|
    15.minutes * (count + 1) # (i.e. 15min, 30min)
  end

  sidekiq_retries_exhausted do |msg|
    user_id = msg['args'].first
    tweet_id = msg['args'].second
    TweetsUser.where(user_id: user_id, tweet_id: tweet_id).first.try(:destroy)
    error = StandardError.new("Unable to participate to contest for user : #{user_id}, tweet : #{tweet_id}")
    Rails.logger.error error.message
    Raven.capture_exception error
  end

end