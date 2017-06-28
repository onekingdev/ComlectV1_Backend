# frozen_string_literal: true

ActiveAdmin.register Timesheet do
  menu false

  decorate_with Admin::TimesheetDecorator

  actions :show

  breadcrumb do
    [
      link_to('Admin', admin_root_path),
      link_to(resource.project, admin_project_path(resource.project))
    ]
  end

  show do
    attributes_table do
      row :id
      row :project
      row :status do |timesheet|
        status_tag timesheet.status.capitalize, class: timesheet.status_css
      end
      row :created_at
      row :first_submitted_at
    end

    div class: 'panel' do
      h3 'Time Logs'
      div class: 'panel_contents' do
        totals_row = OpenStruct.new(
          id: 'TOTAL',
          hours: timesheet.total_hours,
          total_amount: timesheet.total_amount
        )
        table_for timesheet.time_logs + [totals_row] do
          column :id
          column :description
          column :hours
          column :total do |log|
            number_to_currency log.total_amount
          end
        end
      end
    end
  end
end
