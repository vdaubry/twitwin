class AddUniqueIndexOnTweetImage < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE UNIQUE INDEX index_tweets_image_on_created_at_by_month
      ON tweets(date_trunc('month', created_at), image_url);
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX index_tweets_image_on_created_at_by_month;
    SQL
  end
end
