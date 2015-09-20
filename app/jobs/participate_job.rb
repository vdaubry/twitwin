class ParticipateJob
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(tweet_id, user_id)
    return if cancelled?

    logger.info "ParticipateJob : user #{user_id} participate to tweet #{tweet_id}"

    tweet = Tweet.find(tweet_id)
    auth_provider = User.find(user_id).authentication_providers.first
    api = TwitterClient::Api.new(access_token: auth_provider.token, access_token_secret: auth_provider.secret)

    begin
      api.follow(username: tweet.username)
      api.retweet(status_id: tweet.twitter_id)
    rescue TwitterClient::TooManyRequests => error
      logger.error "Got rate limited, cancelling this job and re-scheduling next on in #{error.wait_time} seconds"
      cancel!
      ParticipateJob.perform_in(error.wait_time.seconds, tweet_id, user_id)
    end
  end

  def cancelled?
    Sidekiq.redis {|c| c.exists("cancelled-#{jid}") }
  end

  def cancel!
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end

end