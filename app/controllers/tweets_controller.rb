class HomeController < ApplicationController
  def index
    #Display tweets by date
    @tweets = Tweet.recent.limit(10)
    @played = current_user.tweets.where(id: @tweets.map(&:id)) if current_user
  end
end