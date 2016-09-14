# frozen_string_literal: true
class ProjectExtension::Decorator < Draper::Decorator
  decorates ProjectExtension
  delegate_all

  def confirm_link(text)
    h.link_to text, h.project_extension_path(project), method: :patch, remote: true, data: { params: { confirm: true } }
  end

  def deny_link(text)
    h.link_to text, h.project_extension_path(project), method: :patch, remote: true, data: { params: { deny: true } }
  end
end
