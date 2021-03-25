# frozen_string_literal: true

class DropCpSections < ActiveRecord::Migration[6.0]
  def up
    connection.execute 'drop table if exists compliance_policy_sections'
  end
end
