require "rails_helper"

describe ApplicationController do
render_views

  let(:user) { FactoryGirl.create(:user) }

  describe "current_user" do
    context "user logged in" do
      it "returns user from session" do
        session[:user_id] = user.id
        
        controller.instance_eval{ current_user }.should == user
      end
    end
    
    context "user not logged in" do
      it "returns nil" do
        session[:user_id] = nil
        controller.instance_eval{ current_user }.should == nil
      end
    end
    
    context "user doesn't exist" do
      it "resets user session" do
        session[:user_id] = 666
        controller.instance_eval{ current_user }.should == nil
      end
    end
  end
end