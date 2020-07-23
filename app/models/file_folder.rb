# frozen_string_literal: true

class FileFolder < ActiveRecord::Base
  belongs_to :business
  belongs_to :parent, class_name: 'FileFolder'
  has_many :file_folders, class_name: 'FileFolder', foreign_key: :parent_id
  has_many :file_docs
  scope :root, -> { where(parent_id: nil) }
  validates :name, uniqueness: { scope: %i[business_id parent_id] }
  validate :parent_belongs_to_business
  default_scope { order(created_at: :desc) }

  def all_children_recursion
    file_folders.flat_map do |child_ff|
      child_ff.all_children_recursion << child_ff
    end
  end

  private

  def parent_belongs_to_business
    return true if parent_id.blank?
    parent.business_id == business_id
  end
end
