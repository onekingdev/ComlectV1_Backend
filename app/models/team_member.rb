# frozen_string_literal: true

class TeamMember < ActiveRecord::Base
  belongs_to :team

  has_one :seat
  has_one :specialist_invitation, class_name: 'Specialist::Invitation', dependent: :destroy

  before_validation :set_name

  validates :email, uniqueness: { scope: :team_id }
  validates :first_name, :last_name, :email, presence: true

  after_destroy :clear_seat

  enum role: { basic: 'basic', admin: 'admin', trusted: 'trusted' }

  def clear_seat
    seat&.unassign
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.to_csv(employees, assigned_team_members_ids)
    CSV.generate(headers: true) do |csv|
      csv << %w[Name Title Department Email StartDate EndDate Assigned]
      employees.each do |employee|
        csv << [
          employee.full_name,
          employee.title,
          employee.team&.name,
          employee.email,
          employee.start_date&.strftime('%b %e, %Y'),
          employee.end_date&.strftime('%b %e, %Y'),
          assigned_team_members_ids.include?(employee.id) ? 'Yes' : 'No'
        ]
      end
    end
  end

  private

  def set_name
    self.name = "#{first_name} #{last_name}"
  end
end
