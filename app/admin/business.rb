# frozen_string_literal: true
ActiveAdmin.register Business do
  filter :user_email_cont, label: 'Email'
  filter :business_name, as: :string, label: 'Name'

  controller do
    def scoped_collection
      super.includes :user # prevents N+1 queries to your database
    end
  end

  actions :all, except: %i(new show)

  index do
    column :business_name, label: 'Name' do |business|
      link_to business.business_name, admin_projects_path(q: { business_id_eq: business.id })
    end
    column 'Email', :user, sortable: 'users.email' do |business|
      business.user.email
    end
    column :industries
    column :employees
    column :website
    column :description
    column :linkedin_link
    actions
  end

  # show title: :business_name do
  #   panel "Projects" do
  #     table_for(business.projects) do
  #       column :title
  #       column :location
  #       column :industry
  #       column :jurisdiction
  #       column :description
  #       column :key_deliverables
  #     end
  #   end
  # end

  permit_params :business_name, :industries, :employees, :website, :description, :linkedin_link
  form do |f|
    inputs do
      input :business_name
      input :industries
      input :employees, as: :select, collection: Business::EMPLOYEE_OPTIONS
      input :website
      input :description
      input :linkedin_link
    end
    f.actions
  end
end
