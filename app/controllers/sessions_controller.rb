class SessionsController < ApplicationController
  def create
    user = Oauth::Authorization.new.authorize(oauth_hash: oauth_hash)
    session[:user_id] = user.id

    if user.email
      redirect_to tweets_path
    else
      redirect_to edit_user_path(user)
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You are signed out"
    redirect_to '/'
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