require "rails_helper"

describe SessionsController do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:new_user) { FactoryGirl.create(:user, email: nil) } 
  
  describe "GET create" do
    before(:each) do
      Oauth::Authorization.any_instance.stubs(:authorize).returns(user)
    end
    
    context "new user" do
      it "redirects to user edit path" do
        Oauth::Authorization.any_instance.stubs(:authorize).returns(new_user)
        get :create, provider: "twitter"
        response.should redirect_to tweets_path
      end
    end
    
    it "sets user session" do
      get :create, provider: "twitter"
      session[:user_id].should == User.last.id
    end
  end
  
  describe "GET failure" do
    it "redirects to home page" do
      get :failure
      response.should redirect_to '/'
    end
  end
end

