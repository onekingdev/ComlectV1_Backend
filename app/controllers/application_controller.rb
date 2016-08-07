# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_business
    current_user.business
  end

  def js_alert(message)
    render partial: 'application/js_alert', locals: { message: message }
  end

  def js_notice(message, locals = {})
    render partial: 'application/js_notice', locals: locals.merge(message: message)
  end
  helper_method :js_notice

  def redirect_to_param_or(default)
    redirect_to params[:redirect_to].present? ? params[:redirect_to] : default
  end

  def js_redirect(path)
    render js: "window.location.href = '#{path}';"
  end

  def require_business!
    return if signed_in? && current_business
    render 'forbidden', status: :forbidden, locals: { message: 'Only business accounts can access this page' }
  end

  def require_specialist!
    return if signed_in? && current_user.specialist
    render 'forbidden', status: :forbidden, locals: { message: 'Only specialist accounts can access this page' }
  end

  def render_404
    render file: 'public/404', status: :not_found
  end
end
