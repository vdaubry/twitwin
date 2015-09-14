require "rails_helper"

describe Tweet do
  describe "save" do
    it { FactoryGirl.build(:tweet).save.should == true }
  end

  describe "validations" do
    it { FactoryGirl.build(:tweet, twitter_id: nil).save.should == false }
    it { FactoryGirl.build(:tweet, text: nil).save.should == false }
    it { FactoryGirl.build(:tweet, author_image_url: nil).save.should == false }
    it { FactoryGirl.build(:tweet, tweeted_at: nil).save.should == false }

    it "has unique tweet_id" do
      FactoryGirl.build(:tweet, twitter_id: 1234).save.should == true
      FactoryGirl.build(:tweet, twitter_id: 1234).save.should == false
    end

    it "has unique text per day" do
      FactoryGirl.build(:tweet, created_at: Date.parse("03/11/2010"), text: "foobar").save.should == true
      FactoryGirl.build(:tweet, created_at: Date.parse("03/11/2010"), text: "foobar2").save.should == true
      FactoryGirl.build(:tweet, created_at: Date.parse("01/01/2010"), text: "foobar").save.should == true
      FactoryGirl.build(:tweet, created_at: Date.parse("03/11/2010"), text: "foobar").save.should == false
    end

    it "has unique image per month" do
      Timecop.freeze(Date.parse("01/11/2010"))
      FactoryGirl.build(:tweet, created_at: Date.parse("01/11/2010"), image_url: "http://www.foo.bar/img.jpg", text: "foo1").save.should == true
      FactoryGirl.build(:tweet, created_at: Date.parse("10/11/2010"), image_url: "http://www.foo.bar/img.jpg", text: "foo2").save.should == false
      FactoryGirl.build(:tweet, created_at: Date.parse("10/11/2010"), image_url: "http://www.foo.bar/img2.jpg", text: "foo3").save.should == true
      FactoryGirl.build(:tweet, created_at: Date.parse("01/11/2011"), image_url: "http://www.foo.bar/img.jpg", text: "foo4").save.should == true
    end
  end

  describe "associations" do
    let(:tweet) {FactoryGirl.create(:tweet) }

    before(:each) do
      user = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      TweetsUser.create(user: user, tweet: tweet)
      TweetsUser.create(user: user2, tweet: tweet)
    end

    it "has many tweets_users" do
      tweet.tweets_users.count.should == 2
    end

    it "cascade destroys tweets_users" do
      tweet.destroy
      TweetsUser.count.should == 0
    end

    it "doesn't destroys users" do
      tweet.destroy
      User.count.should == 2
    end
  end
end