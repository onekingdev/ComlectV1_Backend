# frozen_string_literal: true
class RadioPillsInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  def btn_class
    options[:btn_class] || 'btn-default'
  end

  def input(_wrapper_options)
    template.content_tag :div, class: 'btn-group', data: { toggle: 'buttons' } do
      collection.map do |label, value|
        checked = object.public_send(attribute_name) == value
        active_class = checked ? 'active' : nil
        template.content_tag :label, class: "btn #{btn_class} #{active_class}" do
          @builder.radio_button(attribute_name, value) + label.to_s
        end
      end.join.html_safe
    end
  end
end
