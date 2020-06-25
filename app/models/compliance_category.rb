# frozen_string_literal: true

class ComplianceCategory < ActiveRecord::Base
  def checkboxes_arr
    output_hash = {}
    checkboxes.split("\r\n").each do |cb|
      if cb[0] == ' '
        output_hash[output_hash.keys.last].push(cb)
      else
        output_hash[cb] = []
      end
    end
    output_hash
  end
end
