# frozen_string_literal: true
class Specialist::Search
  include ActiveModel::Model

  SORT_BY = { 'Sort by Rating' => 'rating', 'Sort by Experience' => 'experience' }.freeze
  MIN_EXPERIENCE = 3
  MAX_EXPERIENCE = 15
  MAX_LOCATION_RANGE = 100

  attr_accessor :sort_by, :keyword, :jurisdiction_ids, :industry_ids, :rating, :experience, :regulator, :location,
                :lat, :lng, :location_range, :page, :per

  def initialize(attributes = HashWithIndifferentAccess.new)
    self.page = 1
    self.per = 12
    attributes.each do |attr, value|
      public_send "#{attr}=", value.presence
    end
    self.sort_by = 'rating' if sort_by.blank?
    self.industry_ids ||= []
    self.industry_ids.map!(&:presence).compact!
    self.jurisdiction_ids ||= []
    self.jurisdiction_ids.map!(&:presence).compact!
    results # Trigger actual search
  end

  def results
    return @results if @results
    @results = Specialist.preload_associations.public_profiles.distinct
    @results = search(@results)
    @results = filter_industry(@results)
    @results = filter_jurisdiction(@results)
    @results = filter_rating(@results)
    @results = filter_experience(@results)
    @results = filter_regulator(@results)
    @results = filter_location(@results)
    @results = sort(@results)
    @results = paginate(@results)
  end

  def search(records)
    return records if keyword.blank?
    terms = keyword.split(' ')
    records = additional_search_joins(records)
    columns = ['specialists.first_name', 'specialists.last_name', 'specialists.certifications',
               'work_experiences.description', 'work_experiences.company', 'work_experiences.job_title',
               'education_histories.institution', 'skills.name']
    conditions = columns.each_with_index.map do |column|
      Array.new(terms.size) { |i| "#{column} ILIKE :term_#{i}" }.join(' OR ')
    end.join(' OR ')
    values = terms.each_with_index.each_with_object({}) { |(term, i), hash| hash[:"term_#{i}"] = "%#{term}%" }
    records.where(conditions, values).uniq
  end

  def filter_rating(records)
    min, max = rating.to_s.split(';').map(&:to_i)
    return records if rating.blank? || (min == 0 && max == 5)
    if min == 0
      records.where("(ratings_average BETWEEN ? AND ?) OR ratings_average IS NULL", min, max)
    else
      records.where("ratings_average BETWEEN ? AND ?", min, max)
    end
  end

  def filter_experience(records)
    min, max = experience.to_s.split(';').map(&:to_i)
    return records if experience.blank? || (min == MIN_EXPERIENCE && max == MAX_EXPERIENCE)
    max = nil if max == MAX_EXPERIENCE
    records.experience_between(min, max)
  end

  def filter_regulator(records)
    return records if !regulator || regulator == '0'
    records.where(former_regulator: regulator)
  end

  def filter_location(records)
    return records if lat.blank? || lng.blank?
    min, max = location_ranges
    records.distance_between lat, lng, min, max
  end

  def filter_industry(records)
    return records if industry_ids.empty?
    records.joins(:industries).where('industries.id = ANY (?::int[])', "{#{industry_ids.join(',')}}")
  end

  def filter_jurisdiction(records)
    return records if jurisdiction_ids.empty?
    records.joins(:jurisdictions).where('jurisdictions.id = ANY (?::int[])', "{#{jurisdiction_ids.join(',')}}")
  end

  def sort(records)
    case sort_by
    when 'experience'
      records.by_experience
    else
      records.order('ratings_average DESC NULLS LAST')
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

  def additional_search_joins(records)
    records = records.joins('LEFT JOIN work_experiences ON specialists.id = work_experiences.specialist_id')
    records = records.joins('LEFT JOIN education_histories ON specialists.id = education_histories.specialist_id')
    inner_query = 'skills_specialists LEFT JOIN skills on skills_specialists.skill_id = skills.id'
    records.joins("LEFT JOIN (#{inner_query}) on skills_specialists.specialist_id = specialists.id")
  end
end
