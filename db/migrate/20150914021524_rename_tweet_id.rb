class RenameTweetId < ActiveRecord::Migration
  def change
    rename_column :tweets, :tweet_id, :twitter_id
  end
end
