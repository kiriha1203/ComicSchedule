desc "This task is called by the Heroku scheduler add-on"
task :scraping => :environment do
  Scraping.run
end
task :notification_mail => :environment do
  ReleaseMail.run
end