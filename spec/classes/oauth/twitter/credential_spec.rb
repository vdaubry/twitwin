require "rails_helper"

describe Oauth::Twitter::Credential, :vcr => true do
  describe "verify" do
    context "valid credentials" do
      it "returns twitter user id" do
        #Credentials for test account : https://twitter.com/VdaTest
        credential = Oauth::Twitter::Credential.new(token: "3163966989-r24o8ueRiLQo7jgRMg5IpOkK2U3izmZknxRnn4d", secret: "hu9aqreZlCJQZbficxApGXCDjN7Wk550nAhzQFavm3yT3")
        credential.verify.should == 3163966989
      end
    end
    
    context "invalid credentials" do
      it "returns nil" do
        credential = Oauth::Twitter::Credential.new(token: "foo", secret: "bar")
        credential.verify.should == nil
      end
    end
  end
end