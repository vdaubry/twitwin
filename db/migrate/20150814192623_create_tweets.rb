class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer   :tweet_id, :limit => 8,   null: false
      t.text      :text,                    null: false
      t.string    :image_url,               null: true
      t.string    :link,                    null: true
      t.string    :author_image_url,        null: false
      t.datetime  :tweeted_at,              null: false
      t.string    :language,                null: false
      t.timestamps                          null: false
    end

    add_index :tweets, :tweeted_at
    add_index :tweets, :tweet_id, unique: true
  end
end
