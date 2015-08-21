class ParticipateJob
  include Sidekiq::Worker

  def perform(tweet_id, username)
    api = TwitterClient::Api.new
    api.follow(user_id: username)
    api.retweet(status_id: tweet_id)
  end

end