# frozen_string_literal: true

class RemoveCookieDescriptionTosAgreement < ActiveRecord::Migration[6.0]
  def change
    remove_column :tos_agreements, :cookie_description
  end
end
