class RemoveCookieDescriptionTosAgreement < ActiveRecord::Migration
  def change
    remove_column :tos_agreements, :cookie_description
  end
end
