# frozen_string_literal: true
module ApplicationHelper
  include SimpleForm::ActionViewExtensions::FormHelper

  def reverse_sort
    Hash.new('desc').merge('asc' => 'desc', 'desc' => 'asc')[params[:sort_direction]]
  end

  def default_sort
    Hash.new('asc').merge('desc' => 'desc')[params[:sort_direction]]
  end

  def sort_by_url(attribute)
    direction = params[:sort_direction] && params[:sort_by] == attribute ? reverse_sort : default_sort
    current_uri(sort_by: attribute, sort_direction: direction)
  end

  def sort_by_arrow(attribute, default: nil)
    return unless params[:sort_by] == attribute || (default && params[:sort_by].blank?)
    direction = params[:sort_direction] == 'asc' || default == 'asc' ? 'asc' : 'desc'
    (direction == 'asc' ? '&#9650;' : '&#9660;').html_safe
  end

  def link_to_favorite(owner, favorited, options = {}, &block)
    params = { favorite: { favorited_type: favorited.class.model_name, favorited_id: favorited.id } }
    is_favorited = owner.favorited?(favorited)
    css_class = options[:class].presence || 'btn btn-plain'
    css_class += " favorite #{'active' if is_favorited}"
    path = url_for([:toggle, owner.class.model_name.route_key, :favorites])
    content_tag 'button',
                class: css_class,
                data: {
                  url: path,
                  method: :post,
                  remote: true,
                  params: params.to_query
                },
                &block
  end

  def grouped_collection_for_select(array)
    ApplicationDecorator.grouped_collection_for_select array
  end

  def current_uri(query = {})
    url_for params.merge(query)
  end

  alias simple_form_for_super simple_form_for
  def simple_form_for(record, options = {}, &block)
    simple_form_for_super record, options do |f|
      contents = capture(f, &block)
      contents =~ /name="redirect_to"/ ? contents : hidden_field_tag('redirect_to', params[:redirect_to]) + contents
    end
  end

  def link_to_back(name = nil, html_options = nil, &block)
    # rubocop:disable Style/ParallelAssignment
    html_options, name = name, block if block_given?
    url = params[:redirect_to] || request.referer || html_options.delete(:default)
    link_to url, html_options, &name
  end

  def header_class(css_class)
    content_for :header_class, " #{css_class}"
  end

  def render_flash
    classes = { alert: 'warning', notice: 'info' }
    flash.keys.map do |key|
      content_tag 'div', flash[key], class: "alert alert-#{classes[key.to_sym]} m-b-3"
    end.join("\n").html_safe
  end

  def doc_page_num
    params[:page].blank? ? 1 : params[:page].to_i
  end
end
