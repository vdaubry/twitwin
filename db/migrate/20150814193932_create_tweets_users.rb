class CreateTweetsUsers < ActiveRecord::Migration
  def change
    create_table :tweets_users, id: false do |t|
      t.integer     :user_id,       null: false
      t.integer     :tweet_id,      null: false
      t.timestamps                  null: false
    end

    add_index :tweets_users, [:user_id, :tweet_id]
  end
end
