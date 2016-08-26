# frozen_string_literal: true
ActiveAdmin.register ProjectIssue, as: 'Issues' do
  menu parent: 'Projects'

  filter :issue
  filter :created_at

  index do
    selectable_column
    id_column
    column :project, sortable: :project_id
    column 'Escalated by', sortable: :user_id do |issue|
      (issue.user.specialist || issue.user.business)
    end
    column 'Business or Specialist' do |issue|
      issue.user.specialist ? 'Specialist' : 'Business'
    end
    column content_tag(:i, '', class: 'fa fa-eye') do |issue|
      link_to '#', data: { title: 'Issue', content: issue.issue } do
        content_tag :i, '', class: 'fa fa-eye'
      end
    end
    column :status do |issue|
      best_in_place issue, :status, as: :select, collection: ProjectIssue.statuses, url: admin_issue_path(issue)
    end
    column :created_at
    column :updated_at
    actions
  end

  permit_params :status
end
