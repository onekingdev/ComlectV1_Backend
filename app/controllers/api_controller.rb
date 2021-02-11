# frozen_string_literal: true

class ApiController < ApplicationController
  include Pagy::Backend
  respond_to :json

  before_action :set_default_format
  before_action :authenticate_user!
  after_action :add_pagination_headers

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
    @pagy, paginated_scope = pagy_array(scope.to_a, options.merge({ items: per_page, page: page}))
    paginated_scope
  end

  def array_serializer
    ActiveModel::Serializer::CollectionSerializer
  end

  def add_pagination_headers
    pagy_headers_merge(@pagy) if @pagy
  end
end
