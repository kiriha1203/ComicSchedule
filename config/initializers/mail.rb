if Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.smtp_settings = {
    :address => 'smtp.sendgrid.net',
    :domain => 'herokuapp.com',
    :port => 587,
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
elsif Rails.env.development?
  ActionMailer::Base.delivery_method = :letter_opener
else
  ActionMailer::Base.delivery_method = :test
end