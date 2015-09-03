require "rails_helper"

describe UsersController do
  render_views

  let(:user) { FactoryGirl.create(:user) }

  describe "GET edit" do
    it "renders edit template" do
      get :edit, id: user.id
      response.should render_template("edit")
    end
  end

  describe "PUT update" do
    it "updates user email" do
      put :update, id: user.id, user: {email: "foo@linkastor.com"}
      user.reload.email.should == "foo@linkastor.com"
    end

    it "updates user language" do
      put :update, id: user.id, user: {language: "fr"}
      user.reload.language.should == "fr"
    end

    it "redirects to tweets" do
      put :update, id: user.id, user: {email: "foo@linkastor.com"}
      response.should redirect_to tweets_url
    end

    context "invalid email" do
      it "doesn't update user email" do
        old_email = user.email
        put :update, id: user.id, user: {email: "foo"}
        user.reload.email.should == old_email
      end

      it "renders edit" do
        put :update, id: user.id, user: {email: "foo"}
        response.should render_template("edit")
      end
    end
  end
end