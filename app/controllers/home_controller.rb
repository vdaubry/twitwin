class HomeController < ApplicationController
  def index
    if current_user
      redirect_to tweets_path
    else
      render layout: "empty"
    end
  end
end