class UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
  end

  def update
    #TODO : ajouter un user builder , appeler EmailValidator pour verifier que l'email est valide
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to tweets_url
    else
      return render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :avatar, :language)
  end
end