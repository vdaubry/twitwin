require "rails_helper"

describe TweetsController do

  let(:user) { FactoryGirl.create(:user, language: "fr") }

  describe "GET index" do
    before(:each) do
      @tweets = FactoryGirl.create_list(:tweet, 2, language: "en")
    end

    context "not logged in" do
      it "assigns all tweets in english" do
        FactoryGirl.create(:tweet, language: "fr")
        get :index
        assigns(:tweets).should =~ @tweets
      end

      it "returns nil for played tweets" do
        TweetsUser.create(tweet: @tweets.first, user: user)
        get :index
        assigns(:played).should == nil
      end
    end

    context "logged in" do
      before(:each) do
        session[:user_id] = user.id
      end

      it "assigns all tweets with user language" do
        tweet = FactoryGirl.create(:tweet, language: "fr")
        get :index
        assigns(:tweets).should =~ [tweet]
      end

      it "assigns already played tweets" do
        tweets = FactoryGirl.create_list(:tweet, 2, language: "fr")
        TweetsUser.create(tweet: tweets.first, user: user)
        get :index
        assigns(:played).should == [tweets.first]
      end
    end
  end

  describe "POST play_all" do
    context "not logged in" do
      it "returns 301" do
        post :play_all
        response.code.should == "301"
      end
    end

    context "logged in" do
      before(:each) do
        session[:user_id] = user.id
        @tweet1 = FactoryGirl.create(:tweet)
        @tweet2 = FactoryGirl.create(:tweet)
      end

      it "play all tweets" do
        expect {
          post :play_all
        }.to change {TweetsUser.count}.by(2)
      end

      it "play all tweets not already played" do
        TweetsUser.create(user: user, tweet: @tweet1)
        expect {
          post :play_all
        }.to change {TweetsUser.count}.by(1)
      end

      it "redirect to index" do
        post :play_all
        response.should redirect_to(tweets_path)
      end
    end
  end
end

