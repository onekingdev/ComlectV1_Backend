# frozen_string_literal: true

class LocalProject < ApplicationRecord
  has_many :projects
  belongs_to :business
  has_one :visible_project, -> { where(status: Project.statuses[:published]).order(id: :desc).limit(1) }, class_name: 'Project'
  has_many :collaborators, source: :specialist, through: :projects, class_name: 'Specialist'

  def status
    if visible_project.present?
      if visible_project.status == 'published'
        if visible_project.specialist_id.nil?
          'Pending'
        else
          'In Progress'
        end
      elsif visible_project.status == 'draft'
        'Draft'
      elsif visible_project.status == 'complete'
        'Complete'
      end
    else
      'Active'
    end
  end

  def cost
    visible_project.est_budget if visible_project.present?
  end
end
