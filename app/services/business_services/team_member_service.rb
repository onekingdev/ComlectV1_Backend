# frozen_string_literal: true

module BusinessServices
  class TeamMemberService < ApplicationService
    attr_reader \
      :business, :params, :team_member,
      :seat, :team, :invitation, :error

    def initialize(business, params, team_member = nil)
      @business = business
      @params = params
      @team_member = team_member
      @success = true
    end

    def success?
      @success
    end

    def call
      if team_member.present?
        update_team_member
      else
        add_team_member
      end

      self
    end

    private

    def update_team_member
      if team_member.update(params) && team_member.saved_change_to_email?
        Notification::Deliver.got_seat_assigned!(
          team_member.specialist_invitation,
          :new_employee
        )
      else
        @success = false
      end
    end

    def add_team_member
      buid_team_member

      ActiveRecord::Base.transaction do
        unless team_member.save
          @success = false
          return
        end

        load_seat
        seat.assign_to(team_member.id)
        create_invitation
      end

      Notification::Deliver.got_seat_assigned!(invitation, :new_employee)
    rescue => e
      @success = false
      @error = e.message
    end

    def create_invitation
      @invitation = team_member.create_specialist_invitation(team: team)
    end

    def buid_team_member
      @team = business.team
      @team_member = business.team.team_members.build(params)
    end

    def load_seat
      @seat = business.seats.available.first
      add_seat_error unless seat
    end

    def add_seat_error
      @team_member.errors.add(:seat, I18n.t('api.business.team_members.no_available_seats'))
    end
  end
end
