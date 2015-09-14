class TweetsController < ApplicationController
  before_action :authenticate_current_user!, except: [:index]

  def index
    @tweets = Tweet.where(language: language).recent.page(params[:page]).per(50)
    @played = current_user.tweets.where(id: @tweets.map(&:id)) if current_user
    @tweets_presenter = TweetsPresenter.new(lang: language)
  end

  def play_all
    tweets = Tweet.joins("LEFT OUTER JOIN tweets_users ON tweets_users.tweet_id = tweets.id")
                    .where("tweets_users.tweet_id IS NULL")
    tweets.find_each do |tweet|
      TweetsUser.create(tweet: tweet, user: current_user)
    end
    redirect_to tweets_path
  end

  private

  def language
    current_user.try(:language) || "en"
  end
end