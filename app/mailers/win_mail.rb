class WinMail < ApplicationMailer
  def send_win_mail(user, message)
    @message = message
    @user = user
    mail(to: @user.email, subject: "YES !! You won something on twitwin :)")
  end
end
