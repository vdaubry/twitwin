module TwitterClient
  class TweetDto
    delegate :text,
             :retweeted?,
             :id,
             :created_at, to: :tweet

    def initialize(tweet:)
      @tweet = tweet
    end

    def author_image_url
      tweet.user.profile_image_uri.to_s
    end

    def image_url
      tweet.media.select {|tweet| tweet.is_a? Twitter::Media::Photo }
          .map {|tweet| tweet.media_url.to_s }
          .first
    end

    def link
      return if tweet.urls.blank?
      tweet.urls.first.to_s
    end

    def screen_name
      tweet.user.screen_name
    end

    def username
      TweetExtensions::Meta.new(text: tweet.text,
                                author: screen_name).username
    end

    private
    attr_reader :tweet
  end
end