class ParticipateJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, :dead => false

  def perform(tweet_id, user_id)
    tweet = Tweet.find(tweet_id)
    auth_provider = User.find(user_id).authentication_providers.first
    api = TwitterClient::Api.new(access_token: auth_provider.token, access_token_secret: auth_provider.secret)

    api.follow(user_id: tweet.username)
    api.retweet(status_id: tweet.tweet_id)
  end

end