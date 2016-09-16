# frozen_string_literal: true
ActiveAdmin.register Project do
  actions :all, except: %i(new show)
  filter :title
  filter :business

  scope :visible
  scope :recent
  scope :draft_and_in_review
  scope :published
  scope :pending
  scope :active
  scope :complete

  controller do
    def scoped_collection
      super.includes :ratings, :issues
    end
  end

  index do
    column :title
    column :location
    column :industries do |project|
      project.industries.map(&:name).join(', ')
    end
    column :jurisdictions do |project|
      project.jurisdictions.map(&:name).join(', ')
    end
    column :description
    column :key_deliverables
    column 'Escalated' do |project|
      project.escalated? ? status_tag('yes', :ok) : status_tag('no')
      link_to 'Issues', admin_issues_path(q: { project_id_eq: project.id }) if project.escalated?
    end
    actions do |project|
      if project.ratings.count > 0
        link_to 'Ratings', admin_ratings_path(q: { project_id_eq: project.id })
      else
        'No Ratings yet'
      end
    end
  end

  permit_params :title,
                :location,
                :description,
                :key_deliverables,
                :specialist_id,
                industry_ids: [],
                jurisdiction_ids: []
  form do |f|
    inputs do
      input :title
      input :location
      input :industries
      input :jurisdictions
      input :description, as: :text
      input :key_deliverables
      input :specialist
    end
    f.actions
  end
end
