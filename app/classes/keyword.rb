class Keyword
  attr_reader :lang, :file
  def initialize(lang:)
    @lang = lang
    @file = YAML.load_file("config/keywords/keywords-#{lang}.yml")
  end

  def texts
    file["search_texts"]
  end

  def direct_message
    file["direct_message_text"]
  end

  def regex
    file["tweet_regex"]
  end
end