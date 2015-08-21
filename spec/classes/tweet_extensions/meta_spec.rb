require "rails_helper"

describe TweetExtensions::Meta do
  describe "#username" do
    it "returns first twitter handle in text" do
      meta = TweetExtensions::Meta.new(text: "RT @MKBHD: Follow and RT to enter to win these Jaybird X2s! Winner chosen at 8PM EST. GL! http://t.co/aZlsH6GHRK @another",
                      author: "@someuser")
      meta.username.should == "@MKBHD"
    end

    context "no twitter handle in text" do
      it "returns author" do
        meta = TweetExtensions::Meta.new(text: "RT Follow and RT to enter to win these Jaybird X2s! Winner chosen at 8PM EST. GL! http://t.co/aZlsH6GHRK",
                               author: "@someuser")
        meta.username.should == "@someuser"
      end
    end
  end
end
