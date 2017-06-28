# frozen_string_literal: true

class Flag < ApplicationRecord
  belongs_to :flagger, polymorphic: true
  belongs_to :flagged_content, polymorphic: true

  validates :reason, inclusion: {
    in: %w[Inappropriate Harassment Spam] + [
      "Inappropriate, Harassment",
      "Inappropriate, Spam", "Harassment, Spam",
      "Inappropriate, Harassment, Spam"
    ]
  }
  validates :flagger, presence: true
  validates :flagged_content, presence: true

  delegate :project, to: :flagged_content, allow_nil: true

  def offending_user
    if flagged_content.is_a?(Question)
      flagged_content.specialist
    else
      project.business
    end
  end
end
