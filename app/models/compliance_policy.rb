# frozen_string_literal: true

class CompliancePolicy < ActiveRecord::Base
  acts_as_list
  belongs_to :business
  has_many :reminders, as: :linkable
  has_many :published_versions, -> { order(created_at: :desc) }, class_name: 'CompliancePolicy', foreign_key: :src_id
  has_and_belongs_to_many :risks
  belongs_to :source_version, class_name: 'CompliancePolicy', foreign_key: :src_id, optional: true
  validates :name, presence: true
  include PdfUploader[:pdf]
  before_destroy { risks.clear }

  scope :root, -> { where(src_id: nil) }

  enum status: {
    draft: 'draft',
    published: 'published'
  }

  after_commit :update_position, on: :create

  def self.root_published
    policies_collection = []
    root.where(archived: false).find_each do |cpolicy|
      policies_collection.push(cpolicy.published_versions.first) if cpolicy.published_versions.present?
    end
    policies_collection
  end

  def versions
    return published_versions if src_id.nil?
    source_version.published_versions
  end

  def published?
    status == 'published'
  end

  private

  def update_position
    update(position: id)
  end
end
