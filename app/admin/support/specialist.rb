# frozen_string_literal: true
ActiveAdmin.register Specialist, namespace: :support do
  menu parent: 'Users'
  actions :all, except: %i(new)
  filter :user_email_cont, label: 'Email'
  filter :first_name_or_last_name_cont, as: :string, label: 'Name'

  member_action :toggle_suspend, method: :post do
    resource.suspended? ? resource.user.unfreeze! : resource.user.freeze!
    sign_out resource.user if resource.suspended?
    redirect_to collection_path, notice: resource.suspended? ? 'Suspended' : 'Reactivated'
  end

  controller do
    def destroy_resource(resource)
      User::Delete.(resource.user)
    end

    def scoped_collection
      super.includes :user
    end
  end

  index do
    column 'Email', :user, sortable: 'users.email' do |specialist|
      link_to specialist.user.email, support_specialist_path(specialist)
    end
    column :first_name
    column :city
    column :state
    column :country
    column :phone
    column :status do |specialist|
      label, css_class = specialist.suspended? ? %w(Suspended error) : %w(Active yes)
      status_tag label, class: css_class
    end

    actions do |specialist|
      label = specialist.suspended? ? 'Reactivate' : 'Suspend'
      link_to label, toggle_suspend_support_specialist_path(specialist), method: :post
    end
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
