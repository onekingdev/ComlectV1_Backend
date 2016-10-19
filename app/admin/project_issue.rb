# frozen_string_literal: true
ActiveAdmin.register ProjectIssue, as: 'Issues' do
  menu parent: 'Projects'

  actions :all, except: %i(new create)

  filter :status, collection: -> { ProjectIssue.statuses }
  filter :admin_user, collection: -> { AdminUser.pluck(:email, :id) }
  filter :project
  filter :issue
  filter :created_at

  controller do
    def scoped_collection
      super.includes :project
    end
  end

  index do
    selectable_column
    id_column
    column :project, sortable: 'projects.title' do |project_issue|
      link_to project_issue.project.title, edit_admin_project_path(project_issue.project)
    end
    column 'Escalated by', sortable: :user_id do |issue|
      (issue.user.specialist || issue.user.business)
    end
    column 'Assigned to', sortable: 'admin_users.email' do |issue|
      issue.admin_user ? issue.admin_user.email : 'Not assigned'
    end
    column 'Business' do |issue|
      issue.user.business if issue.user.business
    end
    column 'Specialist' do |issue|
      issue.user.specialist if issue.user.specialist
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
    actions
  end

  permit_params :status, :admin_user_id

  form do |f|
    inputs do
      input :status, collection: ProjectIssue.statuses, include_blank: false
      if current_admin_user.super_admin?
        input :admin_user, label: 'Assigned to', collection: AdminUser.pluck(:email, :id), include_blank: 'Not assigned'
      else
        input :admin_user, as: :readonly
      end
      input :project, as: :readonly
      input :user, label: 'Reported by', as: :readonly
      input :issue, as: :readonly
      input :desired_resolution, as: :readonly
    end
    f.actions
  end
end
