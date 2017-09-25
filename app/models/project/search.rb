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
                :regulator, :location_type, :location, :lat, :lng, :location_range, :project_value, :skill_selector,
                :page, :per
  def initialize(attributes = HashWithIndifferentAccess.new)
    self.page = 1
    self.per = 12
    attributes.each do |attr, value|
      public_send "#{attr}=", value.presence
    end
    self.sort_by = 'newest' if sort_by.blank?
    self.project_type = 'one-off' if project_type.blank?
    self.project_value = 'one-off' if project_type.blank?
    self.industry_ids ||= []
    self.industry_ids.map!(&:presence).compact!
    self.jurisdiction_ids ||= []
    self.jurisdiction_ids.map!(&:presence).compact!
    self.skill_names ||= []
    self.skill_names.map!(&:presence).compact!
    results # Trigger actual search
  end

  def results
    return @results if @results
    @results = Project.preload_associations.pending
    @results = filter_type(@results)
    @results = filter_industry(@results)
    @results = filter_jurisdiction(@results)
    @results = filter_experience(@results)
    @results = filter_value(@results)
    @results = filter_regulator(@results)
    @results = filter_location(@results)
    @results = filter_skills(@results)
    @results = sort(@results)
    @results = search(@results)
    @results = paginate(@results)
  end

  def filter_type(records)
    case project_type
    when 'full-time'
      records.full_time
    else
      records.one_off
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
    min, max = experience.to_s.split(';').map(&:to_i)
    min = MIN_EXPERIENCE if min.blank? || min < MIN_EXPERIENCE
    max = MAX_EXPERIENCE if max.blank?
    max = min if max < min
    max = 100 if max == MAX_EXPERIENCE # Future-proof "any experience above 15"
    records.where(minimum_experience: min..max)
  end

  def filter_value(records)
    min, max = project_value.to_s.split(';').map(&:to_i)
    return records if min.to_i.zero? || max.to_i.zero?
    max = Float::INFINITY if max.to_i == MAX_VALUE
    records.where(calculated_budget: (min..max))
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
      records.order(calculated_budget: :desc)
    else
      records.recent
    end
  end

  def paginate(records)
    records.page(page).per(per)
  end

  private

  def location_ranges
    min, max = location_range.to_s.split(';').map(&:presence)
    min = 0 if min.nil? || !min.to_i.between?(0, MAX_LOCATION_RANGE)
    max = MAX_LOCATION_RANGE if max.nil? || !max.to_i.between?(0, MAX_LOCATION_RANGE)
    [min.to_i, max.to_i]
  end
end
