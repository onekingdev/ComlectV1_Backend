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
    column :industries do |business|
      business.industries.map(&:name).join(', ')
    end
    column :employees
    column :website
    column :description
    actions
  end

  permit_params :business_name, :employees, :website, :description, :linkedin_link, industry_ids: []
  form do |f|
    inputs name: 'Business Info' do
      input :business_name
      input :industries
      input :employees, as: :select, collection: Business::EMPLOYEE_OPTIONS
      input :website
      input :linkedin_link
      input :description
    end
    inputs name: 'Location' do
      input :address_1
      input :address_2
      input :zipcode
      input :city
      input :state
      input :country
      input :time_zone
    end
    inputs name: 'Jurisdiction' do
      input :jurisdictions
    end
    inputs name: 'Visibility' do
      input :anonymous
    end
    inputs name: 'Key Contact' do
      input :contact_first_name, label: 'First Name'
      input :contact_last_name, label: 'Last Name'
      input :contact_email, label: 'Email'
      input :contact_job_title, label: 'Job Title'
      input :contact_phone, label: 'Phone'
    end
    f.actions
  end
end
