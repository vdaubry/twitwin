# Preview all emails at http://localhost:3000/rails/mailers/win_mail
class WinMailPreview < ActionMailer::Preview
  def send_win_mail
    WinMail.send_win_mail(User.first, "you are a winner !")
  end
end
