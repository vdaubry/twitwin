namespace :tweets do
  desc "Import tweets from yesterday"
  task import: :environment do
    Language.list.each do |lang|
      TweetImportJob.new.perform(lang)
    end
  end
end
