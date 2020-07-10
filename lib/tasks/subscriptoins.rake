# frozen_string_literal: true

namespace :subscriptions do
  desc 'get names for existing subscriptions'
  task names: :environment do
    subs = Subscription.where(title: nil).all
    puts "subscriptions: #{subs.length}"
    subs.each do |db_sub|
      next if db_sub.stripe_subscription_id.blank?

      begin
        sub = Stripe::Subscription.retrieve(db_sub.stripe_subscription_id)
        product = Stripe::Product.retrieve(sub.plan.product)
      rescue => e
        puts e.message
        next
      end

      to_save = {
        title: product&.name
      }
      to_save[:billing_period_ends] = (Time.at(sub.created).utc + 1.year) if db_sub.billing_period_ends.blank?

      if db_sub.update(to_save)
        puts "updated for db sub: #{db_sub.id}"
      else
        ap db_sub.errors.full_messages
      end
    end
    puts 'done!'
  end
end
