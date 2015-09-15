require "rails_helper"

describe CheckWinJob do
  let (:user_en) { FactoryGirl.create(:user, language: "en") }
  let (:user_fr) { FactoryGirl.create(:user, language: "fr") }

  describe "#perform" do
    context "user signed in with twitter" do
      before(:each) do
        FactoryGirl.create(:authentication_provider, user: user_en)
        FactoryGirl.create(:authentication_provider, user: user_fr)
        Time.stubs(:now).returns(DateTime.parse("01/01/2010"))
      end

      context "direct message received yesterday contains win keyword" do
        before(:each) do
          tweets = FactoryGirl.build_list(:tweet_dao, 2, text: "a win message", tweeted_at: DateTime.parse("01/01/2010"))
          TwitterClient::Api.any_instance.stubs(:direct_messages).returns(tweets)
        end

        it "sends win email" do
          WinMail.expects(:send_win_mail).with(user_en, "a win message").twice
          CheckWinJob.new.perform(user_en.id)
        end

        context "user has no email" do
          it "doesn't send mail" do
            user_en.update(email: nil)
            WinMail.expects(:send_win_mail).with(user_en, "a win message").never
            CheckWinJob.new.perform(user_en.id)
          end
        end

        context "user is not authenticated with twitter" do
          it "doesn't send mail" do
            user_en.authentication_providers.delete_all
            WinMail.expects(:send_win_mail).with(user_en, "a win message").never
            CheckWinJob.new.perform(user_en.id)
          end
        end
      end

      context "direct message received yesterday contains a similar keyword" do
        before(:each) do
          tweets = FactoryGirl.build_list(:tweet_dao, 2, text: "thanks for following us", tweeted_at: DateTime.parse("01/01/2010"))
          TwitterClient::Api.any_instance.stubs(:direct_messages).returns(tweets)
        end

        it "doesn't send mail" do
          WinMail.expects(:send_win_mail).with(user_en, "thanks for following us").never
          CheckWinJob.new.perform(user_en.id)
        end
      end

      context "direct message received yesterday contains french keyword" do
        it "sends win email" do
          tweets = FactoryGirl.build_list(:tweet_dao, 2, text: "Vous avez gagné", tweeted_at: DateTime.parse("01/01/2010"))
          TwitterClient::Api.any_instance.stubs(:direct_messages).returns(tweets)
          WinMail.expects(:send_win_mail).with(user_fr, "Vous avez gagné").twice
          CheckWinJob.new.perform(user_fr.id)
        end
      end

      context "direct message received yesterday contains another french keyword" do
        it "sends win email" do
          tweets = FactoryGirl.build_list(:tweet_dao, 2, text: "Bravo, il faut gagner", tweeted_at: DateTime.parse("01/01/2010"))
          TwitterClient::Api.any_instance.stubs(:direct_messages).returns(tweets)
          WinMail.expects(:send_win_mail).with(user_fr, "Bravo, il faut gagner").twice
          CheckWinJob.new.perform(user_fr.id)
        end
      end

      context "direct message received yesterday doesn't contain win keyword" do
        it "doesn't sends win email" do
          tweets = FactoryGirl.build_list(:tweet_dao, 2, text: "a loose message", tweeted_at: DateTime.parse("01/01/2010"))
          TwitterClient::Api.any_instance.stubs(:direct_messages).returns(tweets)
          WinMail.expects(:send_win_mail).never
          CheckWinJob.new.perform(user_en.id)
        end
      end

      context "credential expired" do
        it "destroy auth provider" do
          TwitterClient::Api.any_instance.stubs(:direct_messages).raises(TwitterClient::CredentialsExpired)
          CheckWinJob.new.perform(user_en.id)
          user_en.authentication_providers.should be_empty
        end
      end
    end
  end
end