# frozen_string_literal: true
ActiveAdmin.register Charge do
  menu parent: 'Financials'

  actions :all, except: %i(new create)

  decorate_with Admin::ChargeDecorator

  filter :amount_in_cents
  filter :status, as: :select, collection: Charge.statuses
  filter :date
  filter :created_at
  filter :updated_at

  collection_action :schedule_pending, method: :post do
    Project.active_for_charges.one_off.find_each(batch_size: 20) do |project|
      PaymentCycle.for(project).create_charges_and_reschedule!
    end
    redirect_to admin_charges_path, notice: 'Done'
  end

  action_item :schedule_pending, only: :index do
    link_to 'Schedule Pending',
            schedule_pending_admin_charges_path,
            method: :post,
            title: 'Schedule payments for approved timesheets and fixed-bugdet projects.'
  end

  collection_action :process_scheduled, method: :post do
    Charge::Processing.process_scheduled!
    redirect_to admin_charges_path, notice: 'Done'
  end

  action_item :process_scheduled, only: :index do
    link_to 'Process Charges Due',
            process_scheduled_admin_charges_path,
            method: :post,
            title: 'Process payments scheduled payments that are due.'
  end

  index do
    selectable_column
    column :project, sortable: 'projects.title' do |charge|
      link_to charge.project, [:admin, charge.project]
    end
    column :amount, sortable: :amount_in_cents, class: 'number' do |charge|
      number_to_currency charge.amount
    end
    column :status do |charge|
      status_tag charge.status, charge.status_css_class
    end
    column :description
    column :date
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :project do |charge|
        link_to charge.project, [:admin, charge.project]
      end
      row :amount do |charge|
        number_to_currency charge.amount
      end
      row :date
      row :process_after
      row :status do |charge|
        status_tag charge.status, charge.status_css_class
      end
      row :status_detail
      row :description
      row :created_at
      row :updated_at
    end
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
