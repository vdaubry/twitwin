require "rails_helper"

describe TwitterClient::Api, vcr: true do
  describe "tweets" do
    it "returns tweets posted since date including urls" do
      tweets = TwitterClient::Api.new.tweets(text: "'rt to win'", options: {language: "en", since: DateTime.parse("17/08/2015")})
      tweets.take(100).count.should == 100
    end

    it "returns only tweets posted after date" do
      since = DateTime.parse("17/08/2015")
      tweets = TwitterClient::Api.new.tweets(text: "'rt to win'", options: {language: "en", since: since })
      tweets.take(100).keep_if {|t| t.created_at > since }.count.should == 100
    end
  end
end