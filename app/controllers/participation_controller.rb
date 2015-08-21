class ParticipationController < ApplicationController
  before_action :check_current_user!
  before_action :set_tweet

  def create
    TweetsUser.create!(user_id: current_user.id,
                      tweet_id: @tweet.id)
    ParticipateJob.perform_async(@tweet.id, @tweet.username)
    render json: {status: :ok}, status: 204
  end

  private
    def set_tweet
      @tweet = Tweet.find(params[:tweet_id])
    end

    def check_current_user!
      render json: {error: "You are not logged in"}, status: 401 unless current_user
    end
end