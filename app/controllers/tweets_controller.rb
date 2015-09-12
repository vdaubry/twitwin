class TweetsController < ApplicationController
  def index
    @tweets = Tweet.where(language: language).recent.page(params[:page]).per(50)
    @played = current_user.tweets.where(id: @tweets.map(&:id)) if current_user
    @tweets_presenter = TweetsPresenter.new(lang: language)
  end

  private

  def language
    current_user.try(:language) || "en"
  end
end