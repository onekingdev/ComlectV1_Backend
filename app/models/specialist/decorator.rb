# frozen_string_literal: true

class Specialist::Decorator < ApplicationDecorator
  decorates Specialist
  delegate_all

  def favorited?(favorited)
    @_all_favorited ||= favorites.pluck(:id, :favorited_type, :favorited_id).each_with_object({}) do |attrs, hash|
      hash["#{attrs[1]}/#{attrs[2]}"] = attrs[0]
    end
    @_all_favorited.key?("#{favorited.model_name}/#{favorited.id}")
  end

  def favorited_id(favorited)
    return nil unless favorited?(favorited)
    @_all_favorited["#{favorited.model_name}/#{favorited.id}"]
  end

  def link_to_favorite(path, is_favorited, options = {}, &block)
    params = { favorite: { favorited_type: model.class.name, favorited_id: model.id } }
    css_class = options[:class].presence || 'btn btn-plain'
    css_class += " favorite #{'active' if is_favorited}"
    h.content_tag 'button',
                  class: css_class,
                  data: {
                    url: path,
                    method: :post,
                    remote: true,
                    params: params.to_query
                  },
                  &block
  end

  def city_state_country
    [city, state, country].map(&:presence).compact.join(', ')
  end

  def years_of_experience
    return @_years_of_experience if @_years_of_experience
    @_years_of_experience = model[:years_of_experience] || (calculate_years_of_experience / 365.0).round
  end

  def sorted_education_histories
    education_histories.where.not(year: nil).sort_by(&:year) + education_histories.where(year: nil)
  end

  def sorted_work_experiences
    far_away = 10.years.ago.to_date
    today = Time.zone.today.to_date
    decorated_work_experiences.sort_by do |exp|
      exp.current? ? today : exp.to || far_away
    end.reverse
  end

  def decorated_work_experiences
    work_experiences.map { |exp| WorkExperience::Decorator.new(exp) }
  end

  def render_stars
    h.render_stars ratings_average
  end

  def certifications_list
    return 'N/A' if certifications.blank?
    h.content_tag 'ul', class: 'list-flush' do
      certifications.split(',').map { |item| h.content_tag('li', item) }.join.html_safe
    end
  end

  def linkedin_url
    normalize_url linkedin_link
  end

  attr_accessor :skill_selector
  def skills_input(builder)
    builder.input(
      :skill_selector,
      placeholder: I18n.t('simple_form.placeholders.project.skills'),
      input_html: {
        class: 'input-lg tt-n',
        autocomplete: 'off',
        data: { source: h.api_skills_path, max: 10 }
      },
      wrapper_html: {
        class: 'm-b-0'
      }
    )
  end

  private

  def calculate_years_of_experience
    work_experiences.compliance.map do |exp|
      exp.from ? ((exp.to || Time.zone.today) - exp.from).to_f : 0.0
    end.reduce(:+) || 0.0
  end
end
