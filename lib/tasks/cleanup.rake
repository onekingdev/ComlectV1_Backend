# frozen_string_literal: true
namespace :cleanup do
  namespace :projects do
    desc 'Update project payment schedules to use enum values'
    task payment_schedule: :environment do
      Project.payment_schedules.each do |key, value|
        Project.where(payment_schedule: key).update_all payment_schedule: value
      end
    end
  end
end
