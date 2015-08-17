class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :tweet_id,          null: false
      t.text    :text,              null: false
      t.string  :image_url,         null: true
      t.string  :link,              null: true
      t.string  :author_image_url,  null: false
      t.timestamps                  null: false
    end

    add_index :tweets, :created_at
  end
end
