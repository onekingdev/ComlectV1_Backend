# frozen_string_literal: true

class TeamMember < ActiveRecord::Base
  belongs_to :team
  has_one :seat

  validates :first_name, presence: true
  # validates :last_name, presence: true
  validates :email, presence: true
  validates :title, presence: true

  before_destroy :clear_seat

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
end
