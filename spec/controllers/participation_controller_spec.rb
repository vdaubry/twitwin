require "rails_helper"

describe ParticipationController do

  let(:tweet) { FactoryGirl.create(:tweet) }
  let(:user) { FactoryGirl.create(:user) }

  describe "POST create" do

    context "not logged in" do
      it "renders 401" do
        post :create, {tweet_id: tweet.id}
        response.code.should == "401"
      end
    end

    context "logged in" do
      before(:each) do
        session[:user_id] = user.id
      end

      it "assigns the tweet to the user" do
        expect {
          post :create, {tweet_id: tweet.id}
        }.to change { TweetsUser.count }.by(1)

        user.reload.tweets.should == [tweet]
      end

      it "participate to corresponding contest" do
        expect {
          post :create, {tweet_id: tweet.id}
        }.to change(ParticipateJob.jobs, :size).by(1)
      end
    end
  end
end

