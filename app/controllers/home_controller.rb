class HomeController < ApplicationController
  def index
    if current_user
      redirect_to tweets_path
    else
      render layout: "empty"
    end
  end

  def error_404
    render file: 'public/404.html', status: 404, layout: false
  end
end