# frozen_string_literal: true
class Specialist::Decorator < Draper::Decorator
  decorates Specialist
  delegate_all

  def city_state_country
    [city, state, country].map(&:presence).compact.join(', ')
  end

  def years_of_experience
    work_experiences.map { |exp| (exp.to - exp.from).to_i }.reduce(:+) / 365
  end

  def render_stars
    h.render_stars 4
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
