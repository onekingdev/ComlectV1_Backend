# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ::Pundit
  include ::MixpanelHelper

  force_ssl if: :ssl_configured?

  impersonates :user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Use lambda not symbol so render_403 uses the default message
  # as opposed to getting passed a Pundit::NotAuthorizedError object
  rescue_from ::Pundit::NotAuthorizedError, with: -> { render_403 }
  rescue_from ::ActionController::InvalidAuthenticityToken, with: -> {
    render_403('Your session expired, please refresh the page')
  }

  # TODO: LAUNCH: Remove
  before_action :beta_protection, if: -> { ::Rails.env.production? }
  def beta_protection
    if protected_beta? && controller_name != 'home'
      redirect_to :root
    elsif beta_site?
      unless authenticate_with_http_basic { |u, p| u == ::ENV.fetch('BETA_USER') && p == ::ENV.fetch('BETA_PASSWORD') }
        request_http_basic_authentication
      end
    end
  end

  before_action -> {
    ::Notification.clear_by_path! current_user, request.path
  }, if: :user_signed_in?

  before_action :check_unrated_project, if: -> {
    user_signed_in? && request.get? && !request.xhr? && request.format.symbol == :html
  }

  private

  def ssl_configured?
    Rails.env.production?
  end

  def check_unrated_project
    if current_business
      project = current_business.projects.pending_business_rating.first
      redirect_to business_project_dashboard_path(project) if project&.requires_business_rating?
    elsif current_specialist
      project = current_specialist.projects.pending_specialist_rating.first
      redirect_to project_dashboard_path(project) if project&.requires_specialist_rating?
    end
  end

  def decorate(object)
    return object if object.is_a?(::Draper::Decorator)
    object.class::Decorator.decorate(object)
  end
  helper_method :decorate

  def current_business
    return nil if protected_beta? # TODO: LAUNCH: Remove
    return @_current_business if @_current_business
    return nil if !user_signed_in? || current_user.business.nil?
    @_current_business = ::Business::Decorator.decorate(current_user.business)
  end
  helper_method :current_business

  def current_specialist
    return nil if protected_beta? # TODO: LAUNCH: Remove
    return @_current_specialist if @_current_specialist
    return nil if !user_signed_in? || current_user.specialist.nil?
    @_current_specialist = ::Specialist::Decorator.decorate(current_user.specialist)
  end
  helper_method :current_specialist

  def current_business_or_specialist
    current_business || current_specialist
  end
  helper_method :current_business_or_specialist

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

  def js_redirect(path, status: :ok)
    @path = path
    render 'application/js_redirect', status: status
  end

  def require_business!
    return if handle_beta_site
    return if user_signed_in? && current_business
    return authenticate_user! unless user_signed_in?
    render 'forbidden', status: :forbidden, locals: { message: 'Only business accounts can access this page' }
  end

  def require_specialist!
    return if handle_beta_site
    return if user_signed_in? && current_specialist
    return authenticate_user! unless user_signed_in?
    render 'forbidden', status: :forbidden, locals: { message: 'Only specialist accounts can access this page' }
  end

  # TODO: LAUNCH: Methods for handling beta protection, delete/disable when site goes live

  def protected_beta?
    ::ENV['BETA_PROTECTED'] == '1' && !beta_site?
  end
  helper_method :protected_beta?

  def beta_site?
    request.domain(2) == ::ENV.fetch('BETA_DOMAIN')
  end

  def handle_beta_site
    return false unless protected_beta?
    redirect_to root_path
    true
  end

  def user_signed_in?
    return false if protected_beta?
    super
  end

  def authenticate_user!
    return super unless handle_beta_site
    redirect_to root_path
  end

  def render_404
    render file: 'public/404', status: :not_found
  end

  def render_403(message = I18n.t('forbidden'))
    format = request.xhr? ? '.js' : ''
    render template: "application/forbidden#{format}",
           locals: { message: message },
           status: :forbidden
  end
end
