class ParticipationController < ApplicationController
  before_action :authenticate_current_user!
  before_action :set_tweet

  def create
    current_user.tweets.create(tweet: @tweet)
    redirect_to tweets_path
  end

  private
    def set_tweet
      @tweet = Tweet.find(params[:tweet_id])
    end
end