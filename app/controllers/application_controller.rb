class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  before_filter :set_user_language

  def authenticate_current_user!
    if current_user.nil?
      session[:user_id] = nil
      flash[:info] = "Please sign in to access this page"
      return redirect_to root_url, status: 301
    end
  end
  
  def current_user
    @current_user ||= User.where(id: session[:user_id]).first
  end

  def set_user_language
    I18n.locale = current_user.language if current_user
  end

end
