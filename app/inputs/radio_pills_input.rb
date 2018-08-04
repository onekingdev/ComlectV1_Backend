# frozen_string_literal: true

class RadioPillsInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  def btn_class
    options[:btn_class] || 'btn-default'
  end

  def input(_wrapper_options)
    template.content_tag :div, class: 'btn-group', data: { toggle: 'buttons' } do
      if collection[0].is_a?(String) && !collection.empty?
        collection2 = collection.map(&proc { |x| [].push(x).push(false) })
        collection2[0][1] = true
        collection = collection2
      end
      collection.map do |label, value|
        each_input label, value
      end.join.html_safe
    end
  end

  private

  def each_input(label, value)
    checked = object.public_send(attribute_name) == value if object
    active_class = checked ? 'active' : nil
    template.content_tag :label, class: "btn #{btn_class} #{active_class}" do
      @builder.radio_button(attribute_name, value, input_html_options) + label.to_s
    end
  end
end
