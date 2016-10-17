# frozen_string_literal: true
class Flag < ActiveRecord::Base
  belongs_to :flagger, polymorphic: true
  belongs_to :flagged_content, polymorphic: true

  validates :reason, inclusion: { in: %w(inappropriate harassment spam) }
  validates :flagger, presence: true
  validates :flagged_content, presence: true

  delegate :project, to: :flagged_content, allow_nil: true

  def offending_user
    if flagger.is_a?(Business)
      flagged_content.project.specialist
    else
      flagged_content.project.business
    end
  end
end
