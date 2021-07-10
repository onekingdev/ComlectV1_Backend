# frozen_string_literal: true

class RadioPillsInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  def btn_class
    options[:btn_class] || 'btn-default'
  end

  def input(_wrapper_options)
    template.content_tag :div, class: 'btn-group', data: { toggle: 'buttons' } do
      if collection[0].is_a?(String)
        collection.each_with_index.map do |label, i|
          each_input label, i.zero?
        end.join.html_safe
      else
        collection.map do |label, value|
          each_input label, value
        end.join.html_safe
      end
    end
  end

  private

  def each_input(label, value)
    tgt_value = object ? value : label
    checked = object ? object.public_send(attribute_name) == value : value
    active_class = checked ? 'active' : nil
    template.content_tag :label, class: "btn #{btn_class} #{active_class}" do
      @builder.radio_button(attribute_name, tgt_value, input_html_options) + label.to_s
    end
  end
end
