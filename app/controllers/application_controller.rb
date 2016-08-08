# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_business
    return @_current_business if @_current_business
    return nil if !signed_in? || current_user.business.nil?
    @_current_business = Business::Decorator.decorate(current_user.business)
  end
  helper_method :current_business

  def current_specialist
    return @_current_specialist if @_current_specialist
    return nil if !signed_in? || current_user.specialist.nil?
    @_current_specialist = Specialist::Decorator.decorate(current_user.specialist)
  end
  helper_method :current_specialist

  def redirect_to_param_or(default)
    redirect_to params[:redirect_to].present? ? params[:redirect_to] : default
  end

  def js_alert(message)
    render partial: 'application/js_alert', locals: { message: message }
  end

  def js_notice(message, locals = {})
    render partial: 'application/js_notice', locals: locals.merge(message: message)
  end
  helper_method :js_notice

  def js_redirect(path)
    render js: "window.location.href = '#{path}';"
  end

  def require_business!
    return if signed_in? && current_business
    render 'forbidden', status: :forbidden, locals: { message: 'Only business accounts can access this page' }
  end

  def require_specialist!
    return if signed_in? && current_specialist
    render 'forbidden', status: :forbidden, locals: { message: 'Only specialist accounts can access this page' }
  end

  def render_404
    render file: 'public/404', status: :not_found
  end
end
