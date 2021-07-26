# frozen_string_literal: true

module ApplicationHelper
  include SimpleForm::ActionViewExtensions::FormHelper

  def self.order_string(field_name, arr)
    arr.map { |val| "#{field_name}='#{val}' desc" }.join(', ')
  end

  def accept_cookies
    cookies[:accept_cookies] = true if current_user && current_user.cookie_agreement.present? && cookies[:accept_cookies].nil?
    cookies[:accept_cookies]
  end

  def user_signed_in_onboarding?
    if current_business && !current_business.onboarding_passed
      false
    else
      user_signed_in?
    end
  end

  def active_class(*args)
    active = args.detect do |arg|
      controller, action = arg.split('#')
      controller_check = controller.match?(%r{\/}) ? controller_path : controller_name
      controller == controller_check && (action.nil? || action == action_name)
    end
    active ? 'active' : ''
  end

  def reverse_sort(direction)
    Hash.new('desc').merge('asc' => 'desc', 'desc' => 'asc')[direction]
  end

  def default_sort(direction)
    Hash.new('asc').merge('desc' => 'desc')[direction]
  end

  def sort_by_url(attribute, default: 'asc')
    direction = sort_direction(default)
    direction = if params[:sort_by] == attribute
      reverse_sort(direction)
    else
      default_sort(default)
    end
    current_uri(sort_by: attribute, sort_direction: direction)
  end

  def sort_direction(default = 'asc')
    params[:sort_direction] == 'desc' || (params[:sort_direction].blank? && default == 'desc') ? 'desc' : 'asc'
  end

  def sort_by_arrow(attribute, default: nil)
    return unless params[:sort_by] == attribute || (default && params[:sort_by].blank?)
    (sort_direction(default) == 'asc' ? '&#9650;' : '&#9660;').html_safe
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

      if contents.match?(/name="redirect_to"/)
        contents
      else
        hidden_field_tag('redirect_to', params[:redirect_to]) + contents
      end
    end
  end

  # rubocop:disable Style/ParallelAssignment
  def link_to_back(name = nil, html_options = nil, &block)
    html_options, name = name, block if block_given?
    url = params[:redirect_to] || request.referer || html_options.delete(:default)
    link_to url, html_options, &name
  end
  # rubocop:enable Style/ParallelAssignment

  def header_class(css_class)
    content_for :header_class, " #{css_class}"
  end

  def render_flash
    classes = { alert: 'warning', notice: 'info' }
    (flash.keys & %w[warning notice alert]).map do |key, val|
      content_tag 'div', raw(flash[key]), class: "alert alert-#{classes[key.to_sym]} m-b-3" if val.present?
    end.join("\n").html_safe
  end

  def doc_page_num
    params[:page].blank? ? 1 : params[:page].to_i
  end

  def new_flag_url(user, project, flaggable)
    flaggable_id = flaggable.class.name.downcase + '_id'
    if user.business.present?
      new_business_project_flag_path(project_id: project.id, flaggable_id => flaggable.id)
    else
      new_project_flag_path(project_id: project.id, flaggable_id => flaggable.id)
    end
  end

  def submit_flag_url(user, project)
    if user.business.present?
      business_project_flags_path(project_id: project.id)
    else
      project_flags_path(project_id: project.id)
    end
  end

  def reward_percent
    spent = current_business_or_specialist.processed_transactions_amount
    return ((spent - 10_000) * 100 / 40_000) * 32.4 / 100 + 1.5 if (spent > BigDecimal('9999')) && (spent < BigDecimal('50001'))
    return (spent * 100 / 50_000) * 32.3 / 100 + 1.5 if (spent > BigDecimal('50000')) && (spent < BigDecimal('150001'))
    return 98.2 if spent > BigDecimal('150000')
  end
end
