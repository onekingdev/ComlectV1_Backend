# frozen_string_literal: true

class TurnkeySolution < ActiveRecord::Base
  belongs_to :turnkey_page
  has_many :project_templates
  accepts_nested_attributes_for :project_templates, allow_destroy: true

  def flavored?
    project_templates.where(flavor: %w[era sma fund]).count.positive?
  end

  def flavors
    project_templates.where(flavor: %w[era sma fund]).collect(&:flavor)
  end

  def budgets
    project_templates.where(flavor: %w[era sma fund]).collect(&:fixed_budget).map(&:to_i)
  end

  def budget_range
    return nil if budgets.blank?
    min_max = budgets.minmax
    out = min_max.map(&proc { |s| s.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse })
    min_max[0] == min_max[1] ? "$#{out[0]}" : "$#{out[0]}-$#{out[1]}"
  end

  def bd?
    project_templates.where(flavor: 'bd').count.positive?
  end

  # rubocop:disable Metrics/AbcSize
  def validate_params(params)
    missing = []
    [[:aum, aum_enabled], [:accounts, accounts_enabled], [:state, principal_office], [:estimated_hours, hours_enabled],\
     [:industries, industries_enabled], [:jurisdictions, jurisdictions_enabled]].each do |v|
      if v[1]
        if params.include?(v[0])
          missing.push(v[0]) if params[v[0]].is_a?(Array) && params[v[0]].reject(&:empty?).empty?
          missing.push(v[0]) if params[v[0]].is_a?(String) && params[v[0]].empty?
        else
          missing.push(v[0])
        end
      end
    end
    missing.push('BD Lines') if bd? && params['bd'].reject(&:empty?).empty?
    missing
  end
  # rubocop:enable Metrics/AbcSize

  def features_array
    new_arr = []
    bag_arr = []
    prev_space = false

    features.split("\r\n").each do |line|
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
    new_arr.push(bag_arr) if bag_arr.present?
    new_arr
  end
end
