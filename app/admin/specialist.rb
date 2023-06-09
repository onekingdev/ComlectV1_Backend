# frozen_string_literal: true

ActiveAdmin.register Specialist do
  menu parent: 'Users'
  decorate_with Admin::SpecialistDecorator

  actions :all, except: %i[new]
  filter :user_email_cont, label: 'Email'
  filter :first_name_or_last_name_cont, as: :string, label: 'Name'
  filter :username, as: :string, label: 'Username'

  batch_action :send_email_to, form: {
    subject: :text,
    body: :textarea
  } do |ids, inputs|
    Specialist.where(id: ids).deep_pluck(user: :email).map(&:values).flatten.map(&:values).flatten.uniq.each do |email|
      AdminMailer.deliver_later :admin_email, email, inputs[:subject], inputs[:body]
    end
    redirect_to collection_path, notice: "Email will be sent to selected #{'specialist'.pluralize(ids.length)}"
  end

  member_action :toggle_suspend, method: :post do
    resource.suspended? ? resource.user.unfreeze! : resource.user.freeze!
    sign_out resource.user if resource.suspended?
    redirect_to collection_path, notice: resource.suspended? ? 'Suspended' : 'Reactivated'
  end

  controller do
    defaults finder: :find_by_username
    def destroy_resource(resource)
      User::Delete.call(resource.user)
    end

    def scoped_collection
      super.includes :user
    end
  end

  index do
    selectable_column
    column 'Email', :user, sortable: 'users.email' do |specialist|
      link_to specialist.user.email, admin_specialist_path(specialist)
    end
    column :experience, label: 'experience' do |specialist|
      link_to specialist.experience, admin_user_path(specialist.user)
    end
    column :username, label: 'Username' do |specialist|
      link_to specialist.username, admin_user_path(specialist.user)
    end
    column :dashboard_unlocked
    column :call_booked
    column :min_hourly_rate
    column :first_name
    column :city
    column :state
    column :country
    column :contact_phone
    column :status do |specialist|
      label, css_class = specialist.suspended? ? %w[Suspended error] : %w[Active yes]
      status_tag label, class: css_class
    end

    actions do |specialist|
      label = specialist.suspended? ? 'Reactivate' : 'Suspend'
      link_to label, toggle_suspend_admin_specialist_path(specialist), method: :post
    end
  end

  show do
    attributes_table do
      row :id
      row :photo do |specialist|
        if specialist.photo
          image_tag specialist.photo_url(:profile), height: 100
        else
          image_tag 'default_userpic.png', height: 100
        end
      end
      row :name, &:full_name
      row :dashboard_unlocked
      row :call_booked
      row :min_hourly_rate
      row :experience
      row :user
      row :visibility do |specialist|
        status_tag specialist.is_public? ? 'Public' : 'Anonymous', specialist.is_public? ? 'yes' : nil
      end
      row :deleted
      row :address, &:full_address
      row :contact_phone
      row :time_zone
      row :linkedin_link do |specialist|
        link_to specialist.linkedin_link, specialist.linkedin_link, target: '_blank' if specialist.linkedin_link.present?
      end
      row :resume do |specialist|
        link_to 'View Resume', specialist.resume_url, target: '_blank' if specialist.resume
      end
      row :industries do |specialist|
        specialist.industries.map(&:to_s).to_sentence
      end
      row :jurisdictions do |specialist|
        specialist.jurisdictions.map(&:to_s).to_sentence
      end
      row :former_regulator
      row :certifications
      row :rating, &:ratings_average
      row :created_at
      row :updated_at
    end
  end

  csv do
    column :id
    column :first_name
    column :last_name
    column :dashboard_unlocked
    column :call_booked
    column :min_hourly_rate
    column(:email) { |specialist| specialist.user.email }
    column :country
    column :state
    column :city
    column :zipcode
    column :contact_phone
    column(:photo) { |specialist| specialist.photo.present? }
    column :linkedin_link
    column :experience
    column :former_regulator
    column :certifications
    column :visibility
    column :lat
    column :lng
    column :point
    column :ratings_average
    column :deleted
    column :time_zone
    column :address_1
    column :address_2
    column(:industries) { |specialist| specialist.industries.map(&:name).join(', ') }
    column(:jurisdictions) { |specialist| specialist.jurisdictions.map(&:name).join(', ') }
    column :created_at
    column :updated_at
  end

  permit_params :resume, :resume_data, :first_name, :last_name, :city, :zipcode, :state, :country, :contact_phone, :linkedin_link,
                :visibility, :experience,
                :former_regulator, :certifications, :dashboard_unlocked, :call_booked, :min_hourly_rate,
                jurisdiction_ids: [], industry_ids: [], skill_ids: []

  form html: { enctype: 'multipart/form-data' } do |f|
    f.inputs name: 'Contact Information' do
      f.input :first_name
      f.input :last_name
      f.input :resume, as: :file, label: 'Resume'
      f.input :experience
      f.input :dashboard_unlocked
      f.input :call_booked
      f.input :min_hourly_rate
      f.input :city
      f.input :zipcode
      f.input :state
      f.input :country
      f.input :contact_phone
      f.input :linkedin_link
      f.input :visibility, collection: Specialist.visibilities.invert
    end

    f.inputs name: 'Areas of Expertise' do
      f.input :jurisdictions
      f.input :industries
      f.input :former_regulator
    end

    f.inputs name: 'Skills' do
      f.input :skills
    end

    f.inputs name: 'Certifications' do
      f.input :certifications
    end

    f.actions
  end
end
