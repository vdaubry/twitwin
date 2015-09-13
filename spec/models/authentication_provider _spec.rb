require "rails_helper"

describe AuthenticationProvider do
  let(:user) { FactoryGirl.create(:user) }

  describe "#create" do
    it { FactoryGirl.build(:authentication_provider).save.should == true }
  end

  describe "validation" do
    it { FactoryGirl.build(:authentication_provider, user_id: nil).save.should == false }
    it { FactoryGirl.build(:authentication_provider, provider: nil).save.should == false }
    it { FactoryGirl.build(:authentication_provider, uid: nil).save.should == false }
    it { FactoryGirl.build(:authentication_provider, token: nil).save.should == false }

    it "has unique uid" do
      FactoryGirl.build(:authentication_provider, uid: "foo").save.should == true
      FactoryGirl.build(:authentication_provider, uid: "foo").save.should == false
    end

    it "has unique provider per user" do
      user2 = FactoryGirl.create(:user)
      FactoryGirl.build(:authentication_provider, user: user, provider: "twitter").save.should == true
      FactoryGirl.build(:authentication_provider, user: user, provider: "twitter").save.should == false
      FactoryGirl.build(:authentication_provider, user: user2, provider: "twitter").save.should == true
    end
  end
end