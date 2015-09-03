class Keywords
  attr_reader :lang
  def initialize(lang:)
    @lang = lang
  end

  def load
    file = "config/keywords/keywords-#{lang}.yml"
    YAML.load_file(file)
  end
end