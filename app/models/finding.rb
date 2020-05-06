# frozen_string_literal: true

class Finding < ActiveRecord::Base
  belongs_to :annual_report
end
