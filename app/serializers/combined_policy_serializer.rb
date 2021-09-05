# frozen_string_literal: true

class CombinedPolicySerializer < ApplicationSerializer
  attributes :id,
             :file

  def file
    object.file_url
  end
end
