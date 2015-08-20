require "rails_helper"

describe Tweet do
  describe "save" do
    it { FactoryGirl.build(:tweet).save.should == true }
  end

  describe "validations" do
    it { FactoryGirl.build(:tweet, tweet_id: nil).save.should == false }
    it { FactoryGirl.build(:tweet, text: nil).save.should == false }
    it { FactoryGirl.build(:tweet, author_image_url: nil).save.should == false }
    it { FactoryGirl.build(:tweet, tweeted_at: nil).save.should == false }

    it "has unique tweet_id" do
      FactoryGirl.build(:tweet, tweet_id: 1234).save.should == true
      FactoryGirl.build(:tweet, tweet_id: 1234).save.should == false
    end

    it "has unique text per day" do
      FactoryGirl.build(:tweet, created_at: Date.parse("03/11/2010"), text: "foobar").save.should == true
      FactoryGirl.build(:tweet, created_at: Date.parse("03/11/2010"), text: "foobar2").save.should == true
      FactoryGirl.build(:tweet, created_at: Date.parse("01/01/2010"), text: "foobar").save.should == true
      FactoryGirl.build(:tweet, created_at: Date.parse("03/11/2010"), text: "foobar").save.should == false
    end
  end
end