# frozen_string_literal: true
ActiveAdmin.register Specialist do
  actions :all, except: [:new]
  filter :user_email_cont, label: 'Email'
  filter :first_name_or_last_name_cont, as: :string, label: 'Name'

  controller do
    def scoped_collection
      super.includes :user # prevents N+1 queries to your database
    end
  end

  index do
    column 'Email', :user, sortable: 'users.email' do |specialist|
      link_to specialist.user.email, admin_specialist_path(specialist)
    end
    column :first_name
    column :city
    column :zipcode
    column :state
    column :country
    column :phone
    column :linkedin_link
    actions
  end

  permit_params :first_name, :last_name, :city, :zipcode, :state, :country, :phone, :linkedin_link
  form do |f|
    inputs do
      input :first_name
      input :last_name
      input :city
      input :zipcode
      input :state
      input :country
      input :phone
      input :linkedin_link
    end
    f.actions
  end
end
