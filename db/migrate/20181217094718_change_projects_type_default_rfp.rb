# frozen_string_literal: true

class ChangeProjectsTypeDefaultRfp < ActiveRecord::Migration
  def change
    change_column_default :projects, :type, 'rfp'
  end
end
