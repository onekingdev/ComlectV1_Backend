# frozen_string_literal: true

class Business::SeatsController < ApplicationController
  def index
    @departments = current_business.viewable_teams
    @active_specialists = current_business.active_specialists.uniq
    teams_ids = current_business.teams.pluck(:id)
    @employees = TeamMember.where(team_id: teams_ids)
    @seats_total = current_business.seats.count
    @seats_available = current_business.seats.available.count
    @seats_taken = @seats_total - @seats_available
    assigned_team_members_ids = current_business.seats.pluck(:team_member_id).compact
    @assigned_team_members = TeamMember.where(id: assigned_team_members_ids)
    @assigned_team_members_ids = @assigned_team_members.pluck(:id)
    respond_to do |format|
      format.html
      format.csv do
        # Override paging to get all records
        send_data TeamMember.to_csv(@employees, @assigned_team_members_ids), filename: 'employees.csv'
      end
    end
  end

  def new; end

  def assign
    return redirect_to business_seats_path, alert: 'No available seats' if current_business.seats.available.count.zero?

    employee = TeamMember.find_by(id: params[:seat_id])
    return redirect_to business_seats_path, alert: 'Invalid employee.' unless employee

    team = current_business.teams.find_by(id: employee.team_id)
    return redirect_to business_seats_path, alert: 'Employee is not in your teams.' unless team

    seat = current_business.seats.available.first

    begin
      Seat.transaction do
        seat.assign_to(params[:seat_id]) # not seat id, team_member_id
        invitation = Specialist::Invitation.create!(
          department: team,
          first_name: employee.first_name,
          last_name: employee.last_name,
          email: employee.email
        )
        Notification::Deliver.got_seat_assigned!(invitation, :new_employee)
      end
      # flash[:notice] = 'Successful!'
    rescue => e
      flash[:alert] = e.message
    end

    redirect_to business_seats_path
  end

  def unassign
    seat = Seat.find_by(team_member_id: params[:seat_id]) # not seat id, team_member_id
    invitation = Specialist::Invitation.find_by(email: seat&.team_member&.email)

    begin
      Seat.transaction do
        seat&.unassign
        invitation&.specialist&.update!(dashboard_unlocked: false)

        # flash[:notice] = 'Successful!'
      end
    rescue => e
      flash[:alert] = e.message
    end

    redirect_to business_seats_path
  end

  def buy
    unless %w[monthly annual].include?(seat_params[:plan])
      return render json: { success: false, message: 'Choose monthly or annual plan' }, status: :unprocessable_entity
    end

    return render json: { success: false, message: 'Minimum 1 seat.' }, status: :unprocessable_entity if seat_params[:cnt].to_i.zero?

    stripe_customer = current_business&.payment_profile&.stripe_customer
    return render json: { success: false, message: 'Add payment source before.' }, status: :unprocessable_entity unless stripe_customer

    total_seats = current_business&.seats&.count
    primary_source = current_business&.payment_profile&.default_payment_source

    (1..seat_params[:cnt].to_i).to_a.each do |i|
      db_subscription = Subscription.create(
        plan: seat_params[:plan],
        business_id: current_business&.id,
        kind_of: :seats,
        title: "Seat ##{total_seats + i}",
        payment_source_id: primary_source&.id
      )

      sub = Subscription.subscribe(
        "seats_#{seat_params[:plan]}",
        stripe_customer,
        quantity: 1,
        period_ends: (Time.now.utc + 1.year).to_i
      )
      db_subscription.update(
        stripe_subscription_id: sub.id,
        billing_period_ends: sub.cancel_at
      )
      Seat.create(
        business_id: current_business.id,
        subscription_id: db_subscription.id,
        subscribed_at: Time.now.utc
      )
    end

    respond_to do |format|
      format.json { render json: { success: true, reload: true } }
    end
  end

  private

  def seat_params
    params.require(:seat).permit(:plan, :cnt)
  end
end
