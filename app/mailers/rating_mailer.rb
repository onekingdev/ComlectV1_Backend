# frozen_string_literal: true

class RatingMailer < ApplicationMailer
  def notification(rating_id)
    rating = Rating.find(rating_id)
    rating.rater == rating.project.business ? specialist_notification(rating) : business_notification(rating)
  end

  private

  def specialist_notification(rating)
    @project = rating.project
    @url = specialists_dashboard_url(anchor: 'ratings-reviews')
    default_notification @project.specialist.user.email
  end

  def business_notification(rating)
    @project = rating.project
    @url = business_dashboard_url(anchor: 'ratings-reviews')
    default_notification @project.business.user.email
  end

  def default_notification(to)
    mail to: to,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: 'You have been rated and reviewed!',
           message_html: render('notification.html'),
           message_text: render('notification.text')
         }
  end
end
