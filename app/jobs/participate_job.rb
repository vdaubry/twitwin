class ParticipateJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, :dead => false

  def perform(tweet_id, username, auth_provider_id)
    auth_provider = AuthenticationProvider.find(auth_provider_id)
    api = TwitterClient::Api.new(access_token: auth_provider.token, access_token_secret: auth_provider.secret)

    api.follow(user_id: username)
    api.retweet(status_id: tweet_id)
  end

end