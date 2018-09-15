# frozen_string_literal: true

class ProjectTemplate < ActiveRecord::Base
  belongs_to :turnkey_solution
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :jurisdictions

  def features_array
    new_arr = []
    bag_arr = []
    prev_space = false

    if public_features.present?
      public_features.split("\r\n").each do |line|
        if line[0] == ' '
          bag_arr.push(line[1..line.length])
          prev_space = true
        else
          if prev_space
            new_arr.push(bag_arr)
            bag_arr = []
            prev_space = false
          end
          new_arr.push(line)
        end
      end
    end
    new_arr.push(bag_arr) if bag_arr.present?
    new_arr
  end
end
