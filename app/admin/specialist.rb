# frozen_string_literal: true

ActiveAdmin.register Specialist do
  menu parent: 'Users'
  decorate_with Admin::SpecialistDecorator

  actions :all, except: %i[new]
  filter :user_email_cont, label: 'Email'
  filter :first_name_or_last_name_cont, as: :string, label: 'Name'

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
    def destroy_resource(resource)
      User::Delete.(resource.user)
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
    column :first_name
    column :city
    column :state
    column :country
    column :phone
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
          image_tag 'icon-specialist.png', height: 100
        end
      end
      row :name, &:full_name
      row :user
      row :visibility do |specialist|
        status_tag specialist.is_public? ? 'Public' : 'Anonymous', specialist.is_public? ? 'yes' : nil
      end
      row :deleted
      row :address, &:full_address
      row :phone
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
      row :rewards_tier
      row :rewards_tier_override
      row :created_at
      row :updated_at
    end
  end

  csv do
    column :id
    column :first_name
    column :last_name
    column(:email) { |specialist| specialist.user.email }
    column :country
    column :state
    column :city
    column :zipcode
    column :phone
    column(:photo) { |specialist| specialist.photo.present? }
    column :linkedin_link
    column :years_of_experience
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
    column :created_at
    column :updated_at
  end

  permit_params :first_name, :last_name, :city, :zipcode, :state, :country, :phone, :linkedin_link, :visibility,
                :former_regulator, :certifications, :rewards_tier_override_id,
                work_experiences_attributes: %i[id _destroy company job_title location from to current compliance description],
                education_histories_attributes: %i[institution degree year],
                jurisdiction_ids: [], industry_ids: [], skill_ids: []

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
      f.input :visibility, collection: Specialist.visibilities.invert
    end

    f.inputs name: 'Work Experience' do
      f.has_many :work_experiences, heading: false, allow_destroy: true do |a|
        a.input :company
        a.input :job_title
        a.input :location
        a.input :from, as: :datepicker
        a.input :to, as: :datepicker
        a.input :current
        a.input :compliance
        a.input :description, as: :text, input_html: { class: 'autogrow', rows: 10, cols: 20 }
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

    inputs name: 'Rewards' do
      input :rewards_tier_override
    end

    f.actions
  end
end
