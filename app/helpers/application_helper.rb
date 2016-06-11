# frozen_string_literal: true
module ApplicationHelper
  def render_flash
    classes = { alert: 'warning', notice: 'info' }
    flash.keys.map do |key|
      content_tag 'div', flash[key], class: "alert alert-#{classes[key.to_sym]}"
    end.join("\n").html_safe
  end
end
