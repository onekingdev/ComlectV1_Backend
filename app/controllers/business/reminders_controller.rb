# frozen_string_literal: true

class Business::RemindersController < ApplicationController
  include RemindersUpdater
  include ActionView::Helpers::TagHelper
  require 'csv'
  before_action :require_business!
  before_action :set_business

  def new
    @reminder = Reminder.new
    @parsed_date = Date.parse(params[:date])
    @reminder.remind_at = @parsed_date
    @reminder.end_date = @parsed_date
    @reminder.repeat_on = (@reminder.remind_at.wday.zero? ? 7 : @reminder.remind_at.wday).to_s
    @action_path = business_reminders_path
  end

  def edit
    @reminder = @business.reminders.find(params[:id])
    if params[:date]
      @occurence = Reminder.new(
        body: @reminder.body,
        remind_at: Date.parse(params[:date]),
        end_date: Date.parse(params[:date]) + (@reminder.duration - 1).days
      )
      @occurence_id = params[:oid].to_i if params[:oid]
    end
    @action_path = business_reminder_path(@reminder)
    render 'business/reminders/new'
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.remindable_id = current_business.id
    @reminder.remindable_type = 'Business'
    @reminder.repeats = nil if @reminder.repeats.blank?
    @reminder.skip_occurencies = []
    @reminder.done_occurencies = {}
    skip_occurence(current_business) if params[:src_id]
    redirect_to business_dashboard_path(reminder: @reminder.remind_at.strftime('%Y-%m-%d')) if @reminder.save
  end

  def destroy
    @reminder = current_business.reminders.find(params[:id])
    tgt_date = @reminder&.remind_at
    if params[:oid]
      @reminder.update(skip_occurencies: @reminder.skip_occurencies + [params[:oid].to_i])
    else
      @reminder&.destroy
    end

    redirect_to business_dashboard_path(reminder: tgt_date&.strftime('%Y-%m-%d'))
  end

  def index
    respond_to do |format|
      format.html do
        render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_business_layout'
      end
      format.pdf do
        render pdf: 'reminders.pdf',
               template: 'business/reminders/index.pdf.erb', encoding: 'UTF-8',
               locals: { remindable: current_business },
               margin: { top:               20,
                         bottom:            25,
                         left:              15,
                         right:             15 }
      end
      format.csv do
        csv_a = []
        @remindable = current_business
        if params[:from_date].blank?
          csv_a.push(%w[Year Month Task Starts Ends Completed Note])
          (@remindable.created_at.year..(Time.zone.today.year + 1)).each do |year|
            csv_a.push(["#{@remindable.name} #{year} Compliance Calendar"])
            Reminder::TOTAL_MONTH.each do |i|
              csv_a.push(['', I18n.t(:date)[:month_names][i]])
              base_date = Date.new(year, 0o1, 0o1)
              tgt_from_date = Date.parse("#{base_date.year}-#{i.to_s.rjust(2, '0')}-01")
              tgt_to_date = tgt_from_date + 1.month
              reminders = Reminder.get_all_reminders(@remindable, tgt_from_date, tgt_to_date)
              if reminders.count.positive?
                reminders.each do |reminder|
                  csv_a.push(['', '', reminder.body, (reminder&.remind_at&.in_time_zone(@remindable.time_zone)&.strftime('%b %-d, %Y')), (reminder&.end_date&.in_time_zone(@remindable.time_zone)&.strftime('%b %-d, %Y')), (reminder&.done_at&.in_time_zone(@remindable.time_zone)&.strftime('%b %-d, %Y') if reminder.done_at.present?), (reminder&.note if reminder.class.name != 'Project')])
                end
              end
            end
            csv_a.push([])
            csv_a.push([])
          end
        else
          csv_a.push(%w[Date Task Starts Ends Completed Note])
          tgt_from_date = Date.parse(params[:from_date])
          tgt_to_date = Date.parse(params[:to_date])
          csv_a.push(["#{@remindable.name} #{tgt_from_date.strftime('%b %-d, %Y')} - #{tgt_to_date.strftime('%b %-d, %Y')} Compliance Calendar"])
          reminders = Reminder.get_all_reminders(@remindable, tgt_from_date, tgt_to_date)
          if reminders.count.positive?
            reminders.each do |reminder|
              csv_a.push(['', reminder.body, (reminder&.remind_at&.in_time_zone(@remindable.time_zone)&.strftime('%b %-d, %Y')), (reminder&.end_date&.in_time_zone(@remindable.time_zone)&.strftime('%b %-d, %Y')), (reminder&.done_at&.in_time_zone(@remindable.time_zone)&.strftime('%b %-d, %Y') if reminder.done_at.present?), (reminder&.note if reminder.class.name != 'Project')])
            end
          end
        end
        @csv_a = csv_a
        headers['Content-Disposition'] = 'attachment; filename="user-list.csv"'
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def update
    @reminder = current_business.reminders.find(params[:id])
    change_reminder_state(params[:note]) if params[:done].present?
    @reminder.update(reminder_params) if params[:reminder]
    @reminder.update(repeats: nil) if @reminder.repeats.blank?
    respond_to do |format|
      format.html do
        redirect_to business_dashboard_path
      end
      format.json do
        render json: :ok
      end
    end
  end

  private

  def reminder_params
    params.require(:reminder).permit(:body, :remind_at, :end_date, :repeats, :end_by, :repeat_every, :repeat_on, :on_type)
  end

  def set_business
    @business = current_business
  end
end
