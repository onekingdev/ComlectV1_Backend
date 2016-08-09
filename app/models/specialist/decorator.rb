# frozen_string_literal: true
class Specialist::Decorator < ApplicationDecorator
  decorates Specialist
  delegate_all

  def link_to_favorite(path, is_favorited, &block)
    data = { params: { favorite: { favorited_type: model.class.name, favorited_id: model.id } } }
    h.link_to path, { method: :post,
                      remote: true,
                      class: "favorite #{'active' if is_favorited}",
                      data: data },
              &block
  end

  def city_state_country
    country = self.country == 'United States' ? 'USA' : self.country
    [city, state, country].map(&:presence).compact.join(', ')
  end

  def years_of_experience
    return @_years_of_experience if @_years_of_experience
    @_years_of_experience =
      model[:years_of_experience] ||
      work_experiences.map { |exp| exp.from ? ((exp.to || Time.zone.today) - exp.from).to_i : 0 }.reduce(:+) / 365
  end

  def sorted_education_histories
    education_histories.sort_by(&:year)
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
