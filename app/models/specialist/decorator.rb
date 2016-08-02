# frozen_string_literal: true
class Specialist::Decorator < ApplicationDecorator
  decorates Specialist
  delegate_all

  def city_state_country
    [city, state, country].map(&:presence).compact.join(', ')
  end

  def years_of_experience
    return @_years_of_experience if @_years_of_experience
    @_years_of_experience =
      model[:years_of_experience] ||
      work_experiences.map { |exp| ((exp.to || Time.zone.today) - exp.from).to_i }.reduce(:+) / 365
  end

  def sorted_education_histories
    education_histories.sort_by(&:year)
  end

  def sorted_work_experiences
    decorated_work_experiences.sort_by(&:to).reverse
  end

  def decorated_work_experiences
    work_experiences.map { |exp| WorkExperience::Decorator.new(exp) }
  end

  def render_stars
    h.render_stars 4
  end

  def certifications_list
    certifications.split(',')
  end

  def linkedin_url
    normalize_url linkedin_link
  end

  attr_accessor :skill_selector
  def skills_input(builder)
    builder.input(:skill_selector,
                  placeholder: I18n.t('simple_form.placeholders.project.skills'),
                  input_html: {
                    class: 'input-lg tt-n',
                    autocomplete: "off",
                    data: { source: h.api_skills_path, max: 10 }
                  },
                  wrapper_html: {
                    class: 'm-b-0'
                  })
  end
end
