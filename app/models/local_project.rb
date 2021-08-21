# frozen_string_literal: true

class LocalProject < ApplicationRecord
  attr_accessor :hide_on_calendar
  has_many :projects
  belongs_to :business
  has_one :visible_project, -> { order(id: :desc).where(specialist_id: nil).limit(1) }, class_name: 'Project'
  has_many :collaborators, source: :specialist, through: :projects, class_name: 'Specialist'
  has_many :reminders, as: :linkable
  has_and_belongs_to_many :specialists

  has_many :messages, as: :thread
  has_many :documents, as: :uploadable

  validates :title, presence: true

  enum status: {
    inprogress: 'inprogress',
    draft: 'draft',
    complete: 'complete',
    pending: 'pending'
  }

  def deep_status
    if visible_project.present?
      visible_project.status
    else
      status
    end
  end

  def cost
    visible_project.est_budget if visible_project.present?
  end
end
