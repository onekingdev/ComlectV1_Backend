# frozen_string_literal: true

desc 'This task is called by the Heroku scheduler add-on to mail metrics monthly to admins'
task mail_metrics: :environment do
  AdminMailer.metrics_csv.deliver! if Time.zone.now.day == 1
end
