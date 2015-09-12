require "rails_helper"

describe TweetImportJob do
  describe "#perform with network", vcr: true do
    it "creates yesterdays tweets in DB" do
      today = DateTime.parse("17/08/2015")
      Timecop.travel(today)
      TweetImportJob.new.perform("fr")
      Tweet.count.should == 77
      Tweet.where("tweeted_at < ?", today-1.day).count.should == 0
    end
  end

  describe "#perform without network", vcr: false do
    before(:each) do
      tweets = FactoryGirl.build(:tweet_dao)
      TwitterClient::Api.any_instance.stubs(:tweets).returns([tweets])
    end

    it "accepts valid tweets retweeted tweets" do
      TwitterTweet.any_instance.stubs(:retweeted?).returns(false)
      TweetImportJob.new.perform("fr")
      Tweet.count.should == 1
    end

    it "rejects retweeted tweets" do
      TwitterTweet.any_instance.stubs(:retweeted?).returns(true)
      TweetImportJob.new.perform("fr")
      Tweet.count.should == 0
    end

    it "rejects tweets without image" do
      TwitterTweet.any_instance.stubs(:retweeted?).returns(false)
      TwitterTweet.any_instance.stubs(:image_url).returns(nil)
      TweetImportJob.new.perform("fr")
      Tweet.count.should == 0
    end
  end
end