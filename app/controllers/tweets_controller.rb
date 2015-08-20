class TweetsController < ApplicationController
  def index
    @tweets = Tweet.recent.page(params[:page]).per(50)
    @played = current_user.tweets.where(id: @tweets.map(&:id)) if current_user
  end
end