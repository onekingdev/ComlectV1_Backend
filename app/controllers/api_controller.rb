# frozen_string_literal: true

class ApiController < ApplicationController
  include Pagy::Backend
  respond_to :json
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_default_format
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  after_action :add_pagination_headers
  self.responder = ::ApiResponder

  private

  def set_default_format
    request.format = :json
  end

  def per_page
    params[:per_page] || Pagy::VARS[:items]
  end

  def page
    params[:page]
  end

  def paginate(scope, **options)
    @pagy, paginated_scope = pagy_array(scope.to_a, options.merge(items: per_page, page: page))
    paginated_scope
  end

  def array_serializer
    ActiveModel::Serializer::CollectionSerializer
  end

  def add_pagination_headers
    pagy_headers_merge(@pagy) if @pagy
  end

  def user_not_authorized
    respond_with  error: 'You are not authorized to perform that action', status: 403
  end
end
