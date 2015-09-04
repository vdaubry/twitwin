class UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    builder = Builders::UserBuilder.new
    builder.update(user: @user, params: user_params) do |on|
      on.success do
        redirect_to tweets_url
      end

      on.failure do
        return render 'edit'
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :avatar, :language)
  end
end