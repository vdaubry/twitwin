class AddUsernameToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :username, :string, null: false
  end
end
