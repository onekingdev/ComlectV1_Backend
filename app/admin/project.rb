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
    actions
  end

  permit_params :title, :location, :industries, :jurisdiction, :description, :key_deliverables
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
