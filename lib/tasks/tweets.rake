namespace :tweets do
  desc "Import tweets from yesterday"
  task import: :environment do
    TweetImportJob.new.perform
  end

end
