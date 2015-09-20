require "rails_helper"

describe TwitterClient::Api, vcr: true do
  describe "#tweets" do
    it "returns tweets posted since date including urls" do
      tweets = TwitterClient::Api.new.tweets(text: "'rt to win'", count: 100, options: {language: "en", since: DateTime.parse("17/08/2015")})
      tweets.count.should == 100
    end

    it "returns only tweets posted after date" do
      since = DateTime.parse("17/08/2015")
      tweets = TwitterClient::Api.new.tweets(text: "'rt to win'", count: 100, options: {language: "en", since: since })
      tweets.keep_if {|t| t.created_at > since }.count.should == 100
    end
  end

  # it "catch Forbidden error" do
  #   Twitter::REST::Client.any_instance.stubs(:follow).raises(Twitter::Error::TooManyRequests.new)
  #   expect {
  #     TwitterClient::Api.new.follow(username: "VdaTest")
  #   }.to raise_error(TwitterClient::TooManyRequests)
  # end

  # describe "#direct_messages" do
  #   it "returns direct messages posted since date" do
  #     api = TwitterClient::Api.new(access_token: "3163966989-r24o8ueRiLQo7jgRMg5IpOkK2U3izmZknxRnn4d",access_token_secret: "hu9aqreZlCJQZbficxApGXCDjN7Wk550nAhzQFavm3yT3")
  #     tweets = api.direct_messages(options: {since: DateTime.parse("17/08/2015"), count: 20})
  #     tweets.count.should == 20
  #   end
  # end
end