# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def js_alert(message)
    render partial: 'application/js_alert', locals: { message: message }
  end

  def redirect_to_param_or(default)
    redirect_to params[:redirect_to].present? ? params[:redirect_to] : default
  end

  def js_redirect(path)
    render js: "window.location.href = '#{path}';"
  end

  def require_business!
    return if current_user.business
    render 'forbidden', status: :forbidden, locals: { message: 'Only business accounts can access this page' }
  end

  def render_404
    render file: 'public/404', status: :not_found
  end
end
