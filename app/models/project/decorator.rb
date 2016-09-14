# frozen_string_literal: true
# rubocop:disable Metrics/ClassLength
class Project::Decorator < ApplicationDecorator
  decorates Project
  decorates_association :business, with: Business::Decorator
  delegate_all

  def status_text
    return 'Escalated' if escalated?
    return 'Active' if active?
    return 'Complete' if complete?
    'Pending'
  end

  def dashboard_path
    if h.current_specialist
      one_off? ? h.specialists_project_dashboard_path(self) : h.specialists_project_path(self)
    else
      one_off? ? h.business_project_dashboard_path(self) : h.business_project_path(self)
    end
  end

  def percent_complete
    return 0 unless starts_on && ends_on
    total = (ends_on - starts_on).to_f
    remaining = (ends_on - Time.zone.today).to_i
    percent = (1 - (remaining / total)) * 100
    return 100 if percent > 100
    percent < 0 ? 0 : percent
  end

  def specialist_project_href(specialist)
    return h.project_path(self) if full_time?
    specialist == model.specialist ? h.project_dashboard_path(self) : h.project_path(self)
  end

  def business_project_href
    return h.business_project_path(self) if full_time?
    complete? || active? ? h.business_project_dashboard_path(self) : h.business_project_path(self)
  end

  def confirm_delete
    "Are you sure you want to delete this project?<h2>#{title}</h2>
     This can't be undone and this project will no longer appear in your dashboard, even as a draft.".html_safe
  end

  def location_details
    return 'Remote' if remote?
    return location if full_time?
    [location_type_humanized, location.presence].compact.join(', ')
  end

  def key_deliverables_list
    h.content_tag 'ul', class: 'list-flush' do
      if key_deliverables.blank?
        h.content_tag 'li', 'N/A'
      else
        key_deliverables.split(',').map { |item| h.content_tag('li', item) }.join.html_safe
      end
    end
  end

  def dollars
    amount = if full_time?
               annual_salary
             else
               hourly_pricing? ? hourly_rate : fixed_budget
             end
    h.number_to_currency(amount, precision: 0) + ("/hr, est. #{estimated_hours} hrs." if hourly_rate?).to_s
  end

  def start_and_duration
    string = starts_on.strftime('%b %d, %Y')
    return string if full_time?
    "#{string} (#{duration})"
  end

  def duration
    h.pluralize (ends_on - starts_on).to_i, 'day', 'days'
  end

  def type_humanized
    { 'one_off' => 'One-time Project', 'full_time' => 'Full-time Role' }[type]
  end

  def minimum_experience_humanized
    return 'None' if minimum_experience.blank?
    "#{minimum_experience} Years"
  end

  def location_type_humanized
    Project::LOCATIONS.find { |_key, value| value == location_type }&.first
  end

  def payment_schedule_humanized
    Project::PAYMENT_SCHEDULES.find { |_key, value| value == payment_schedule }&.first
  end

  def hourly_rate_input(builder)
    builder.input :hourly_rate,
                  required: true,
                  as: :string,
                  input_html: { class: 'input-lg', data: { masked: '#0.00', reverse: true } }
  end

  def fixed_budget_input(builder)
    builder.input :fixed_budget,
                  required: true,
                  as: :string,
                  input_html: { class: 'input-lg', data: { masked: '#0.00', reverse: true } }
  end

  def hourly_payment_schedule_input(builder)
    builder.input :hourly_payment_schedule,
                  collection: Project::HOURLY_PAYMENT_SCHEDULES,
                  include_blank: I18n.t('simple_form.placeholders.project.hourly_payment_schedule'),
                  required: true,
                  input_html: { class: 'input-lg js-select' }
  end

  def fixed_payment_schedule_input(builder)
    builder.input :fixed_payment_schedule,
                  collection: Project::FIXED_PAYMENT_SCHEDULES,
                  include_blank: I18n.t('simple_form.placeholders.project.fixed_payment_schedule'),
                  required: true,
                  input_html: { class: 'input-lg js-select' }
  end

  def industries_input(builder)
    builder.input :industry_ids,
                  as: :grouped_select,
                  collection: grouped_collection_for_select(Industry.sorted),
                  group_method: :all,
                  group_label_method: :label,
                  placeholder: I18n.t('simple_form.placeholders.project.industries'),
                  input_html: { class: 'input-lg js-select', multiple: true }
  end

  def jurisdictions_input(builder)
    builder.input :jurisdiction_ids,
                  as: :grouped_select,
                  collection: grouped_collection_for_select(Jurisdiction.sorted),
                  group_method: :all,
                  group_label_method: :label,
                  placeholder: I18n.t('simple_form.placeholders.project.jurisdictions'),
                  input_html: { class: 'input-lg js-select', multiple: true }
  end

  attr_accessor :skill_selector
  def skills_input(builder)
    builder.input(:skill_selector,
                  placeholder: I18n.t('simple_form.placeholders.project.skills'),
                  input_html: {
                    class: 'input-lg tt-n',
                    autocomplete: "off",
                    data: { source: h.api_skills_path, max: 10 }
                  })
  end
end
