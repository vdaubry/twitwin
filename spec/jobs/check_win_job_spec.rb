require "rails_helper"

describe CheckWinJob do
  let (:user) { FactoryGirl.create(:user, language: "en") }
  describe "#perform" do
    context "user signed in with twitter" do
      before(:each) do
        FactoryGirl.create(:authentication_provider, user: user)
      end

      context "direct message received yesterday contains win keyword" do
        it "sends win email" do
          Time.stubs(:now).returns(DateTime.parse("01/01/2010"))
          tweets = FactoryGirl.build_list(:tweet_dao, 2, text: "a win message", tweeted_at: DateTime.parse("01/01/2010"))
          TwitterClient::Api.any_instance.stubs(:direct_messages).returns(tweets)
          WinMail.expects(:send_win_mail).with(user, "a win message").twice
          CheckWinJob.new.perform(user.id)
        end
      end

      context "direct message received yesterday contains french keyword" do
        it "sends win email" do
          user = FactoryGirl.create(:user, language: "fr")
          FactoryGirl.create(:authentication_provider, user: user)
          Time.stubs(:now).returns(DateTime.parse("01/01/2010"))
          tweets = FactoryGirl.build_list(:tweet_dao, 2, text: "Vous avez gagné", tweeted_at: DateTime.parse("01/01/2010"))
          TwitterClient::Api.any_instance.stubs(:direct_messages).returns(tweets)
          WinMail.expects(:send_win_mail).with(user, "Vous avez gagné").twice
          CheckWinJob.new.perform(user.id)
        end
      end

      context "direct message received yesterday contains another french keyword" do
        it "sends win email" do
          user = FactoryGirl.create(:user, language: "fr")
          FactoryGirl.create(:authentication_provider, user: user)
          Time.stubs(:now).returns(DateTime.parse("01/01/2010"))
          tweets = FactoryGirl.build_list(:tweet_dao, 2, text: "Bravo, il faut gagner", tweeted_at: DateTime.parse("01/01/2010"))
          TwitterClient::Api.any_instance.stubs(:direct_messages).returns(tweets)
          WinMail.expects(:send_win_mail).with(user, "Bravo, il faut gagner").twice
          CheckWinJob.new.perform(user.id)
        end
      end

      context "direct message received yesterday doesn't contain win keyword" do
        it "doesn't sends win email" do
          Time.stubs(:now).returns(DateTime.parse("01/01/2010"))
          tweets = FactoryGirl.build_list(:tweet_dao, 2, text: "a loose message", tweeted_at: DateTime.parse("01/01/2010"))
          TwitterClient::Api.any_instance.stubs(:direct_messages).returns(tweets)
          WinMail.expects(:send_win_mail).never
          CheckWinJob.new.perform(user.id)
        end
      end
    end
  end
end