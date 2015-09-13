require "rails_helper"

describe User do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:tweet) { FactoryGirl.create(:tweet) }
  
  describe "#create" do
    it { FactoryGirl.build(:user).save.should == true }

    describe "validations" do
      it "has unique emails" do
        FactoryGirl.build(:user, email: "foo@bar.com").save.should == true
        FactoryGirl.build(:user, email: "foo@bar.com").save.should == false
      end

      it "can create a user without email" do
        FactoryGirl.build(:user, email: nil).save.should == true
      end

      it "can create multiple user without email" do
        FactoryGirl.build(:user, email: nil).save.should == true
        FactoryGirl.build(:user, email: nil).save.should == true
      end
    end

    context "relations" do
      it "has many authentication providers" do
        FactoryGirl.create(:authentication_provider, user: user, provider: "twitter")
        FactoryGirl.create(:authentication_provider, user: user, provider: "facebook")
        user.reload.authentication_providers.count.should == 2
      end

      it "destroys authentication providers when destroyed" do
        FactoryGirl.create(:authentication_provider, user: user)
        expect {
          user.destroy
        }.to change { AuthenticationProvider.count }.by(-1)
      end

      describe "has many tweets" do
        before(:each) do
          TweetsUser.create(user: user, tweet: tweet)
        end

        it { user.reload.tweets.should == [tweet] }

        it "destroys user tweets when destroyed" do
          expect {
            user.destroy
          }.to change { TweetsUser.count }.by(-1)
        end

        it "cannot have the same tweet twice" do
          TweetsUser.create(user: user, tweet: tweet)
          user.reload.tweets.should == [tweet]
        end
      end
    end
  end
end