# frozen_string_literal: true

class ChangeTosAgreementColumnNames < ActiveRecord::Migration[6.0]
  def change
    rename_column :tos_agreements, :description, :tos_description
    add_column :tos_agreements, :cookie_description, :string
  end
end
