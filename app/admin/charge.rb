# frozen_string_literal: true
ActiveAdmin.register Charge do
  menu parent: 'Financials'

  actions :all, except: %i(new create)

  filter :amount_in_cents
  filter :status, as: :select, collection: Charge.statuses
  filter :process_after
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :project
    column :amount, sortable: :amount_in_cents, class: 'number' do |charge|
      number_to_currency charge.amount
    end
    column :status do |charge|
      status_tag charge.status, class: if charge.processed?
                                         'yes'
                                       else
                                         charge.error? ? 'error' : nil
                                       end
    end
    column :description
    column :process_after
    column :created_at
    actions
  end

  permit_params :amount_in_cents, :process_after, :description

  form do |_f|
    inputs do
      input :amount_in_cents
      input :process_after, as: :datepicker
      input :description
    end
    actions
  end
end
