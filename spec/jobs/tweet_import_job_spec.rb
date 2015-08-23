require "rails_helper"

describe TweetImportJob, vcr: true do
  describe "#perform" do
    it "creates yesterdays tweets in DB" do
      today = DateTime.parse("17/08/2015")
      Timecop.travel(today)
      TweetImportJob.new.perform
      Tweet.count.should == 58
      Tweet.where("tweeted_at < ?", today-1.day).count.should == 0
    end
  end
end