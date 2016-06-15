# frozen_string_literal: true
class Project::Decorator < Draper::Decorator
  decorates Project
  delegate_all

  def hourly_rate_input(builder)
    builder.input :hourly_rate,
                  required: true,
                  wrapper: :vertical_form,
                  input_html: { class: 'input-lg' },
                  wrapper_html: { class: ('hidden' if fixed_pricing?) }
  end

  def fixed_budget_input(builder)
    builder.input :fixed_budget,
                  required: true,
                  wrapper: :vertical_form,
                  input_html: { class: 'input-lg' },
                  wrapper_html: { class: ('hidden' if hourly_pricing?) }
  end

  def hourly_payment_schedule_input(builder)
    builder.input :hourly_payment_schedule,
                  collection: Project::HOURLY_PAYMENT_SCHEDULES,
                  include_blank: false,
                  required: true,
                  wrapper: :vertical_form,
                  input_html: { class: 'input-lg js-select' },
                  wrapper_html: { class: ('hidden' if fixed_pricing?) }
  end

  def fixed_payment_schedule_input(builder)
    builder.input :fixed_payment_schedule,
                  collection: Project::FIXED_PAYMENT_SCHEDULES,
                  include_blank: false,
                  required: true,
                  wrapper: :vertical_form,
                  input_html: { class: 'input-lg js-select' },
                  wrapper_html: { class: ('hidden' if hourly_pricing?) }
  end

  def industries_input(builder)
    builder.input :industry_ids,
                  as: :grouped_select,
                  collection: grouped_collection_for_select(Industry.all),
                  group_method: :all,
                  group_label_method: :label,
                  prompt: I18n.t('simple_form.placeholders.project.industries'),
                  input_html: { class: 'input-lg js-select', multiple: true }
  end

  def jurisdictions_input(builder)
    builder.input :jurisdiction_ids,
                  as: :grouped_select,
                  collection: grouped_collection_for_select(Jurisdiction.all),
                  group_method: :all,
                  group_label_method: :label,
                  prompt: I18n.t('simple_form.placeholders.project.jurisdictions'),
                  input_html: { class: 'input-lg js-select', multiple: true }
  end

  def grouped_collection_for_select(array)
    [array].map do |collection|
      collection.define_singleton_method :all do
        collection
      end
      def collection.label
        'Select all'
      end
      collection
    end
  end
end
