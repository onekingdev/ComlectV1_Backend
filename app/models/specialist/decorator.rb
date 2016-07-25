# frozen_string_literal: true
class Specialist::Decorator < Draper::Decorator
  decorates Specialist
  delegate_all

  attr_accessor :skill_selector
  def skills_input(builder)
    builder.input(:skill_selector,
                  placeholder: I18n.t('simple_form.placeholders.project.skills'),
                  input_html: {
                    class: 'input-lg tt-n',
                    autocomplete: "off",
                    data: { source: h.api_skills_path, max: 10 }
                  })
  end
end
