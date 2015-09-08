module TwitterClient
  class TweetDao
    delegate :text, to: :tweet
    attr_reader :tweet
    def initialize(tweet:)
      @tweet = tweet
    end
  end
end