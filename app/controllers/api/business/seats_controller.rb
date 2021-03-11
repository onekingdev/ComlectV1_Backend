# frozen_string_literal: true

class Api::Business::SeatsController < ApiController
  before_action :require_business!

  def assign
    respond_with errors: { seats: 'No available seats' } and return if current_business.seats.available.count.zero?

    employee = TeamMember.find_by(id: params[:seat_id])

    respond_with errors: { seats: 'Invalid employee' } and return unless employee

    team = current_business.teams.find_by(id: employee.team_id)

    respond_with errors: { seats: 'Employee is not in your teams' } and return unless team

    seat = current_business.seats.available.first

    begin
      Seat.transaction do
        seat.assign_to(params[:seat_id])
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
      respond_with errors: { seats: "#{e.message}" } and return
    end

    respond_with @invitation, serializer: InvitationSerializer
  end

  private

  def invitation_params
    params.require(:invitation).permit(:role)
  end
end
