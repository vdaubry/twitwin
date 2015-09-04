class Keywords
  attr_reader :lang, :file
  def initialize(lang:)
    @lang = lang
    @file = YAML.load_file("config/keywords/keywords-#{lang}.yml")
  end

  def texts
    file["texts"]
  end
end