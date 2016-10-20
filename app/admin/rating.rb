# frozen_string_literal: true
ActiveAdmin.register Rating do
  actions :all, except: %i(show edit)
  filter :project
  filter :review

  controller do
    def scoped_collection
      super.includes :rater, :project
    end
  end

  index do
    column :project
    column 'From', :rater
    column :to
    column :review
    column :stars, &:value
    actions
  end
end
