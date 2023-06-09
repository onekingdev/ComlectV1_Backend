# frozen_string_literal: true

class LocalProject < ApplicationRecord
  attr_accessor :hide_on_calendar

  belongs_to :business
  belongs_to :owner, polymorphic: true, optional: true

  has_many :projects
  has_one :visible_project, -> { order(id: :desc).where(specialist_id: nil).limit(1) }, class_name: 'Project'
  has_many :local_projects_specialists
  has_many :collaborators, source: :specialist, through: :local_projects_specialists, class_name: 'Specialist'
  has_many :reminders, as: :linkable
  has_many :messages, as: :thread
  has_many :documents, as: :uploadable

  has_and_belongs_to_many :specialists

  alias_attribute :name, :title

  validates :title, :starts_on, :ends_on, presence: true
  validate if: -> { starts_on.present? && ends_on.present? } do
    errors.add :ends_on, 'Date must occur after start date' if starts_on > ends_on
  end

  enum status: {
    inprogress: 'inprogress',
    draft: 'draft',
    complete: 'complete',
    pending: 'pending'
  }

  def status_business
    if visible_project.present?
      visible_project.status_business
    else
      'draft'
    end
  end

  def cost
    visible_project.est_budget if visible_project.present?
  end
end
