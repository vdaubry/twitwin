require "rails_helper"

describe Tweet do
  describe "save" do
    it { FactoryGirl.build(:tweet).save.should == true }
  end

  describe "validations" do
    it { FactoryGirl.build(:tweet, tweet_id: nil).save.should == false }
    it { FactoryGirl.build(:tweet, text: nil).save.should == false }
    it { FactoryGirl.build(:tweet, author_image_url: nil).save.should == false }
  end
end