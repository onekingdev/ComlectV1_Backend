# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  skip_before_action :verify_authenticity_token, only: :destroy

  respond_to :js, :html

  # POST /resource/sign_in
  def create
    respond_to do |format|
      format.html { super }
      format.js do
        if (self.resource = warden.authenticate(auth_options))
          set_flash_message!(:notice, :signed_in)
          sign_in(resource_name, resource)
          resource.update(inactive_for_period: false)
          @js_redirect = after_sign_in_path_for(resource)
        else
          flash.now[:warning] = 'Invalid email or password'
        end
      end
    end
    mixpanel_track_later 'Sign In' if signed_in?
  end

  # DELETE /resource/sign_out
  def destroy
    user = current_user
    respond_to do |format|
      format.html { super }
      format.js do
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        set_flash_message! :notice, :signed_out if signed_out
        cookies.delete
      end
    end
    mixpanel_track_later 'Sign Out', user: user
  end

  def squarespace
    headers['Access-Control-Allow-Credentials'] = 'true'
    headers['Access-Control-Allow-Origin'] = 'https://complect.squarespace.com'
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    cu = current_user
    if current_specialist
      render json: {
        specialist: true,
        business: false,
        name: current_specialist.username,
        unread: cu.notifications.unread.count,
        fullname: current_specialist.to_s
      }
    elsif current_business
      render json: { specialist: false, business: true, name: current_business.username, unread: cu.notifications.unread.count }
    else
      render json: { specialist: false, business: false, name: nil, unread: nil }
    end
  end

  def squarespace_destroy
    # for some reason with DELETE method doesn't work on devise's destroy
    headers['Access-Control-Allow-Credentials'] = 'true'
    headers['Access-Control-Allow-Origin'] = 'https://complect.squarespace.com'
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    Devise.sign_out_all_scopes ? sign_out : sign_out(current_user)
    redirect_to 'https://www.complect.com/'
    # render json: { signed_out: signed_out }
  end

  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || (resource.business ? business_dashboard_path : specialists_dashboard_path)
    # if resource.business
    #   business_dashboard_path
    # else
    #   super
    # end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
