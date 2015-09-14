class TweetsPresenter
  def initialize(lang:)
    @keyword = Keyword.new(lang: lang)
  end

  def username(tweet:)
    tweet.username.gsub("@","")
  end

  def link(tweet:)
    "https://twitter.com/#{username(tweet: tweet)}/statuses/#{tweet.twitter_id}"
  end

  def tweet_message(tweet:)
    regex = /#{keyword.regex}/
    text_in_bold = tweet.text.match(regex).try(:[], 0)
    normal_text = tweet.text.split(regex).try(:[], 0)
    "#{normal_text} <b>#{text_in_bold}</b>".html_safe
  end

  private
  attr_reader :keyword
end