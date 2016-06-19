# frozen_string_literal: true
module ApplicationHelper
  include SimpleForm::ActionViewExtensions::FormHelper

  def decorate(object)
    object.class::Decorator.decorate(object)
  end

  alias simple_form_for_super simple_form_for
  def simple_form_for(record, options = {}, &block)
    simple_form_for_super record, options do |f|
      contents = capture(f, &block)
      contents =~ /name="redirect_to"/ ? contents : hidden_field_tag('redirect_to', params[:redirect_to]) + contents
    end
  end

  def header_class(css_class)
    content_for :header_class, " #{css_class}"
  end

  def render_flash
    classes = { alert: 'warning', notice: 'info' }
    flash.keys.map do |key|
      content_tag 'div', flash[key], class: "alert alert-#{classes[key.to_sym]}"
    end.join("\n").html_safe
  end
end
