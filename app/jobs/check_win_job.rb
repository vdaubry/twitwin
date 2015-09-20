class CheckWinJob
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    return if user.email.nil? || user.authentication_providers.blank?

    logger.info "CheckWinJob: read direct messages for user id : #{user.id}"
    auth_provider = user.authentication_providers.first

    begin
      send_message_if_win(auth_provider, user)
    rescue TwitterClient::CredentialsExpired => e
      logger.error "Unable to get direct messages sur user #{user_id} because credentials expired : #{e.message}"
      auth_provider.destroy
    end
  end


  def send_message_if_win(auth_provider, user)
    api = TwitterClient::Api.new(access_token: auth_provider.token, access_token_secret: auth_provider.secret)
    direct_messages = api.direct_messages(options: {since: 1.day.ago, count: 200})
    win_messages = direct_messages.select do |msg|
      next unless msg.respond_to?(:text)
      keywords(user.language).any? {|key| msg.text.match(/\b#{key}\b/).present? }
    end
    win_messages.each do |win_msg|
      WinMail.send_win_mail(user, win_msg.text).try(:deliver_now)
    end
  end

  def keywords(language)
    Keyword.new(lang: language).direct_message
  end
end