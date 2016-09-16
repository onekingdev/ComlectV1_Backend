# frozen_string_literal: true
ActiveAdmin.register Specialist do
  actions :all, except: %i(show new)
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
    f.inputs name: 'Contact Information' do
      f.input :first_name
      f.input :last_name
      f.input :city
      f.input :zipcode
      f.input :state
      f.input :country
      f.input :phone
      f.input :linkedin_link
    end
    f.inputs name: 'Work Experience' do
      f.has_many :work_experiences, heading: false, allow_destroy: true do |a|
        a.input :company
        a.input :job_title
        a.input :location
        a.input :from
        a.input :to
        a.input :current
        a.input :compliance
        a.input :description, as: :text, input_html: { class: 'autogrow', rows: 10, cols: 20, maxlength: 10 }
      end
    end
    f.inputs name: 'Areas of Expertise' do
      f.input :jurisdictions
      f.input :industries
      f.input :former_regulator
    end
    f.inputs name: 'Skills' do
      f.input :skills
    end
    f.inputs name: 'Education' do
      f.has_many :education_histories, heading: false, allow_destroy: true do |a|
        a.input :institution
        a.input :degree
        a.input :year
      end
    end
    f.inputs name: 'Certifications' do
      f.input :certifications
    end
    f.inputs name: 'Photo' do
      # f.input :photo_data
    end
    f.inputs name: 'Resume' do
      # f.input :resume_data
    end
    f.inputs name: 'Visibility' do
      f.input :visibility
    end
    f.actions
  end
end
