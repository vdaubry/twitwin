class AddUniqueIndexOnTextTweets < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE UNIQUE INDEX index_tweets_on_created_at_by_day
      ON tweets(date_trunc('day', created_at), text);
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX index_tweets_on_created_at_by_day;
    SQL
  end
end
