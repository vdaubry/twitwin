require "rails_helper"

describe ParticipateJob do

  let(:user) { FactoryGirl.create(:user) }
  let(:tweet) { FactoryGirl.create(:tweet, username: "foobar", tweet_id: 12345) }

  describe "#perform", vcr: true do
    context "user signed in with twitter" do
      before(:each) do
        FactoryGirl.create(:authentication_provider, user: user)
      end

      it "follows user" do
        TwitterClient::Api.any_instance.expects(:follow).with(username: "foobar").once
        ParticipateJob.new.perform(tweet.id, user.id)
      end

      it "retweets" do
        TwitterClient::Api.any_instance.expects(:retweet).with(status_id: 12345).once
        ParticipateJob.new.perform(tweet.id, user.id)
      end
    end
  end
end