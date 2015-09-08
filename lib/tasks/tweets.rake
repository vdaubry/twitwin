namespace :tweets do
  desc "Import tweets from yesterday"
  task import: :environment do
    Language.list.each do |lang|
      #TODO : use async task to parrallelize work
      TweetImportJob.new.perform(lang)
    end
  end
end
