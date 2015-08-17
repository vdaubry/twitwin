class SessionsController < ApplicationController
  def create
    user = Oauth::Authorization.new.authorize(oauth_hash: oauth_hash)
    session[:user_id] = user.id
    
    redirect_to tweets_path
  end
  
  def failure
    flash[:alert] = params[:message]
    redirect_to '/'
  end
  
  protected

  def oauth_hash
    request.env['omniauth.auth']
  end
end