# frozen_string_literal: true
class Specialist::Search
  include ActiveModel::Model

  SORT_BY = { 'Sort by Rating' => 'rating', 'Sort by Experience' => 'experience' }.freeze
  MAX_EXPERIENCE = 15
  MAX_LOCATION_RANGE = 50

  attr_accessor :sort_by, :keyword, :jurisdiction_ids, :industry_ids, :rating, :experience, :regulator, :location,
                :lat, :lng, :location_range, :page, :per

  def initialize(attributes = HashWithIndifferentAccess.new)
    self.per = 12 unless attributes.key?('per')
    attributes.each do |attr, value|
      public_send "#{attr}=", value.presence
    end
    self.industry_ids ||= []
    self.industry_ids.map!(&:presence).compact!
    self.jurisdiction_ids ||= []
    self.jurisdiction_ids.map!(&:presence).compact!
    results # Trigger actual search
  end

  def results
    return @_results if @_results
    @results = Specialist.all
    @results = search(@results)
    @results = filter_industry(@results)
    @results = filter_jurisdiction(@results)
    @results = filter_rating(@results)
    @results = filter_experience(@results)
    @results = filter_regulator(@results)
    @results = filter_location(@results)
    @results = sort(@results)
    @results = paginate(@results)
    @_results = @results.to_a
  end

  def search(records)
    return records if keyword.blank?
    terms = keyword.split(' ')
    columns = %w(first_name last_name)
    conditions = columns.each_with_index.map do |column|
      Array.new(terms.size) { |i| "#{column} ILIKE :term_#{i}" }.join(' OR ')
    end.join(' OR ')
    values = terms.each_with_index.each_with_object({}) { |(term, i), hash| hash[:"term_#{i}"] = "%#{term}%" }
    records.where(conditions, values)
  end

  def filter_rating(records)
    return records unless rating.present?
    min, max = rating.split(';').map(&:to_i)
    if min == 0
      records.where("(rating_avg BETWEEN ? AND ?) OR rating_avg IS NULL", min, max)
    else
      records.where("rating_avg BETWEEN ? AND ?", min, max)
    end
  end

  def filter_experience(records)
    return records unless experience.present?
    min, max = experience.split(';').map(&:to_i)
    max = nil if max == MAX_EXPERIENCE
    records.experience_between(min, max)
  end

  def filter_regulator(records)
    return records if !regulator || regulator == '0'
    records.where(former_regulator: regulator)
  end

  def filter_location(records)
    min, max = location_ranges
    max ||= 10_000
    return records if (min == 0 && max == 10_000) || lat.blank? || lng.blank?
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
      records.order('rating_avg DESC NULLS LAST')
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
