require File.expand_path(File.dirname(__FILE__) + "/environment")

rails_root = Rails.root.to_s

set :environment, :development
set :output, "#{rails_root}/log/cron.log"

every 1.day, :at => '10:00 am' do
  runner "Scraping.run"
  runner "ReleaseMail.run"
end

# 変更後は　bundle exec wheneverで確認
# bundle exec whenever --update-crontab で更新
# crontab -l で設定されているcronをみる