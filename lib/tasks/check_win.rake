namespace :check do
  desc "Reads direct messages to see if users won something"
  task win: :environment do
    User.joins(:authentication_providers).where("email IS NOT NULL").find_each do |user|
      #TODO : use async task to parrallelize work
      CheckWinJob.new.perform(user.id)
    end
  end
end
