# frozen_string_literal: true

class Project::Search
  include ActiveModel::Model

  SORT_BY = { 'Sort by Newest' => 'newest', 'Sort by Start Date' => 'start_date', 'Sort by Budget' => 'budget' }.freeze
  KEYWORD_SEARCH_COLUMNS = %w[title description key_deliverables].freeze
  MIN_EXPERIENCE = 3
  MAX_EXPERIENCE = 15
  MAX_LOCATION_RANGE = 100
  MAX_VALUE = 50_000

  attr_accessor :project_type, :sort_by, :keyword, :jurisdiction_ids, :industry_ids, :skill_names, :experience,
                :regulator, :location_type, :location, :lat, :lng, :location_range, :budget, :duration, :skill_selector,
                :page, :per_page, :pricing_type

  def initialize(attributes = HashWithIndifferentAccess.new)
    attributes.each do |attr, value|
      public_send "#{attr}=", value.presence
    end
    self.sort_by = 'newest' if sort_by.blank?
    self.project_type = 'one-off' if project_type.blank?
    self.budget = ["0,#{MAX_VALUE}"] if budget.blank?
    self.duration = ["0,#{MAX_VALUE}"] if duration.blank?
    self.industry_ids ||= []
    self.industry_ids.map!(&:presence).compact!
    self.jurisdiction_ids ||= []
    self.jurisdiction_ids.map!(&:presence).compact!
    self.jurisdiction_ids.map!(&:presence).compact!
    self.skill_names ||= []
    self.skill_names.map!(&:presence).compact!
    results # Trigger actual search
  end

  def results
    return @results if @results
    @results = Project.preload_association.pending
    @results = filter_type(@results)
    @results = filter_industry(@results)
    @results = filter_jurisdiction(@results)
    @results = filter_experience(@results)
    # @results = filter_budget(@results)
    @results = filter_duration(@results)
    @results = filter_regulator(@results)
    @results = filter_location(@results)
    @results = filter_skills(@results)
    @results = filter_pricing_type(@results)
    @results = sort(@results)
    @results = search(@results)
  end

  def filter_type(records)
    case project_type
    when 'full-time'
      records.full_time
    else
      records.one_off.or(records.rfp)
    end
  end

  def search(records)
    return records if keyword.blank?
    terms = keyword.split(' ')
    columns = %w[title description key_deliverables]
    conditions = columns.each_with_index.map do |column|
      Array.new(terms.size) { |i| "#{column} ILIKE :term_#{i}" }.join(' OR ')
    end.join(' OR ')
    values = terms.each_with_index.each_with_object({}) { |(term, i), hash| hash[:"term_#{i}"] = "%#{term}%" }
    records.where(conditions, values)
  end

  def filter_experience(records)
    return records if experience.blank?
    conditions = experience.each_with_index.map do |_checkbox, i|
      "minimum_experience BETWEEN :from_#{i} AND :to_#{i}"
    end.join(' OR ')
    records.where(conditions, compile_params(experience))
  end

  def filter_budget(records)
    return records if budget.blank?
    conditions = budget.each_with_index.map do |_checkbox, i|
      "(calculated_budget BETWEEN :from_#{i} AND :to_#{i}) OR (est_budget BETWEEN :from_#{i} AND :to_#{i})"
    end.join(' OR ')
    records.where(conditions, compile_params(budget))
  end

  def filter_duration(records)
    return records if duration.blank?
    conditions = duration.each_with_index.map do |_checkbox, i|
      "(ends_on - starts_on BETWEEN :from_#{i} AND :to_#{i})"
    end.join(' OR ')
    records.where(conditions, compile_params(duration))
  end

  def filter_regulator(records)
    return records if !regulator || regulator == '0'
    records.where(only_regulators: regulator)
  end

  def filter_location(records)
    case location_type
    when 'onsite'
      return records.onsite if lat.blank? || lng.blank?
      min, max = location_ranges
      records.onsite.distance_between lat, lng, min, max
    when 'remote'
      records.remote
    when 'remote_and_travel'
      records.remote_and_travel
    else
      records
    end
  end

  def filter_industry(records)
    return records if industry_ids.empty?
    records.joins(:industries).where('industries.id = ANY (?::int[])', "{#{industry_ids.join(',')}}")
  end

  def filter_jurisdiction(records)
    return records if jurisdiction_ids.empty?
    records.joins(:jurisdictions).where('jurisdictions.id = ANY (?::int[])', "{#{jurisdiction_ids.join(',')}}")
  end

  def filter_skills(records)
    return records if skill_names.empty?
    records.with_skills(skill_names)
  end

  def sort(records)
    case sort_by
    when 'start_date'
      records.order(starts_on: :asc)
    when 'budget'
      records.order(est_budget: :desc)
    when 'duration'
      records.order('ends_on - starts_on DESC')
    else
      records.recent
    end
  end

  def filter_pricing_type(records)
    return records if pricing_type.blank?

    records.where(pricing_type: pricing_type)
  end

  private

  def compile_params(input_arr)
    input_arr.each_with_index.each_with_object({}) { |(checkbox, i), hash|
      from, to = checkbox.split(',')
      hash[:"from_#{i}"] = from
      hash[:"to_#{i}"] = to
    }
  end

  def location_ranges
    min, max = location_range.to_s.split(';').map(&:presence)
    min = 0 if min.nil? || !min.to_i.between?(0, MAX_LOCATION_RANGE)
    max = MAX_LOCATION_RANGE if max.nil? || !max.to_i.between?(0, MAX_LOCATION_RANGE)
    [min.to_i, max.to_i]
  end
end
