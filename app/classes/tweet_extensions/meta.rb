module TweetExtensions
  class Meta
    attr_reader :text, :author
    def initialize(text:, author:)
      @text = text
      @author = author
    end

    def username
      text.scan(/@[a-zA-Z0-9]*/).first || author
    end
  end
end