# frozen_string_literal: true
ActiveAdmin.register Skill, namespace: :support do
  filter :name
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :name do |skill|
      link_to skill.name, [:support, skill]
    end
    column :created_at
    column :updated_at
    actions
  end

  permit_params :name

  form do |_f|
    inputs do
      input :name
    end
    actions
  end
end
