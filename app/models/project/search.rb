# frozen_string_literal: true
# rubocop:disable Metrics/ClassLength
class Project::Search
  include ActiveModel::Model

  SORT_BY = { 'Sort by Newest' => 'newest', 'Sort by Start Date' => 'start_date', 'Sort by Budget' => 'budget' }.freeze
  KEYWORD_SEARCH_COLUMNS = %w(title description key_deliverables).freeze
  MIN_EXPERIENCE = 3
  MAX_EXPERIENCE = 15
  EXP_RANGES = {
    (3..7) => '3-7',
    (7..10) => '7-10',
    (11..15) => '11-15',
    (15..Float::INFINITY) => '15+'
  }.freeze
  MAX_LOCATION_RANGE = 50
  MIN_VALUE = 5000
  MAX_VALUE = 50_000

  attr_accessor :project_type, :sort_by, :keyword, :jurisdiction_ids, :industry_ids, :skill_names, :experience,
                :regulator, :location_type, :location, :lat, :lng, :location_range, :project_value, :skill_selector,
                :page, :per

  # rubocop:disable Metrics/AbcSize
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
    @results = Project.preload_associations.published.pending
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
    records.search(keyword)
  end

  def filter_experience(records)
    min, _max = experience.to_s.split(';').map(&:to_i)
    min = 8 if min == 7 # Because of the overlapping range
    min = MIN_EXPERIENCE if min.blank? || min < MIN_EXPERIENCE
    min_range = EXP_RANGES.detect { |(range, _value)| range.include?(min) }[1]
    records.where(minimum_experience: min_range)
  end

  def filter_value(records)
    min, max = project_value.to_s.split(';').map(&:to_i)
    return records if min.to_i == 0 || max.to_i == 0
    records.where(calculated_budget: (min..max))
  end

  def filter_regulator(records)
    return records if !regulator || regulator == '0'
    records.where(only_regulators: regulator)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def filter_location(records)
    case location_type
    when 'onsite'
      min, max = location_ranges
      max ||= 10_000
      return records.onsite if (min == 0 && max == 10_000) || lat.blank? || lng.blank?
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
    min ||= 0
    max = nil if max.to_i >= MAX_LOCATION_RANGE
    [min.to_i, max]
  end
end
