class CheckWinJob
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    return if user.email.nil?

    keywords = Keyword.new(lang: user.language).direct_message

    auth_provider = user.authentication_providers.first
    api = TwitterClient::Api.new(access_token: auth_provider.token, access_token_secret: auth_provider.secret)

    direct_messages = api.direct_messages(options: {since: 1.day.ago, count: 200})
    win_messages = direct_messages.select do |msg|
      keywords.any? {|key| msg.text.match(/\b#{key}\b/).present? }
    end
    win_messages.each do |win_msg|
      WinMail.send_win_mail(user, win_msg.text).try(:deliver_now)
    end
  end
end