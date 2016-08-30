# frozen_string_literal: true
class ProjectEnd::Decorator < Draper::Decorator
  decorates ProjectEnd
  delegate_all

  def confirm_link(text)
    h.link_to text, h.project_end_path(project), method: :patch, remote: true, data: { params: { confirm: true } }
  end

  def deny_link(text)
    h.link_to text, h.project_end_path(project), method: :patch, remote: true, data: { params: { deny: true } }
  end
end
