# frozen_string_literal: true

class AddReferenceableToCharges < ActiveRecord::Migration
  def change
    add_reference :charges, :referenceable, index: false, polymorphic: true
    add_index :charges, %i[referenceable_type referenceable_id], unique: true
  end
end
