# frozen_string_literal: true

ActiveAdmin.register Business, namespace: :support do
  menu parent: 'Users'
  filter :user_email_cont, label: 'Login Email'
  filter :business_name, as: :string, label: 'Business Name'

  controller do
    def destroy_resource(resource)
      User::Delete.call(resource.user)
    end

    def scoped_collection
      super.includes :user
    end
  end

  actions :all, except: %i[new]

  member_action :toggle_suspend, method: :post do
    resource.suspended? ? resource.user.unfreeze! : resource.user.freeze!
    sign_out resource.user if resource.suspended?
    redirect_to collection_path, notice: resource.suspended? ? 'Suspended' : 'Reactivated'
  end

  index do
    column :business_name, label: 'Business Name' do |business|
      link_to business.business_name, support_projects_path(q: { business_id_eq: business.id })
    end
    column 'Login Email', :user, sortable: 'users.email' do |business|
      business.user.email
    end
    column :industries do |business|
      business.industries.map(&:name).join(', ')
    end
    column :employees
    column :website
    column :status do |business|
      label, css_class = business.suspended? ? %w[Suspended error] : %w[Active yes]
      status_tag label, class: css_class
    end

    actions do |business|
      label = business.suspended? ? 'Reactivate' : 'Suspend'
      link_to label, toggle_suspend_support_business_path(business), method: :post
    end
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
