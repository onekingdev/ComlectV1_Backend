# frozen_string_literal: true

class Api::Business::SeatsController < ApiController
  before_action :require_business!
  skip_before_action :verify_authenticity_token

  def index
    respond_with current_business.all_employees, each_serializer: Business::SpecialistSerializer
  end

  def assign
    respond_with(errors: { seats: 'No available seats' }) && return if current_business.seats.available.count.zero?

    employee = current_business.teams.first.team_members.create(invitation_params)

    respond_with(errors: { seats: 'Invalid employee' }) && return unless employee

    team = current_business.teams.find_by(id: employee.team_id)

    respond_with(errors: { seats: 'Employee is not in your teams' }) && return unless team

    seat = current_business.seats.available.first

    begin
      Seat.transaction do
        seat.assign_to(employee.id)
        @invitation = Specialist::Invitation.create!(
          department: team,
          first_name: employee.first_name,
          last_name: employee.last_name,
          email: employee.email,
          team: team,
          role: Specialist::Invitation.roles[invitation_params[:role]]
        )
        Notification::Deliver.got_seat_assigned!(@invitation, :new_employee)
      end
    rescue => e
      respond_with(errors: { seats: e.message.to_s }) && (return)
    end

    respond_with @invitation, serializer: InvitationSerializer
  end

  private

  def invitation_params
    params.require(:invitation).permit(:first_name, :last_name, :email, :start_date)
  end
end
