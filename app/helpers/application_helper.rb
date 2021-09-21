# frozen_string_literal: true

module ApplicationHelper
  def sort_direction(default = 'asc')
    params[:sort_direction] == 'desc' || (params[:sort_direction].blank? && default == 'desc') ? 'desc' : 'asc'
  end
end
