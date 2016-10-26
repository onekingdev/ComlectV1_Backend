# frozen_string_literal: true
module MixpanelHelper
  def mixpanel_track_later(event, args = {})
    mixpanel do
      user = args.delete(:user)
      flash[:mixpanel_event] = event
      flash[:mixpanel_user_id] = user.id if user
      flash[:mixpanel_args] = args.to_query
    end
  end

  def mixpanel
    yield if ENV['MIXPANEL_PROJECT_TOKEN'].present?
  end
end
