# frozen_string_literal: true
class ReadonlyInput < Formtastic::Inputs::StringInput
  def to_html
    input_wrapping do
      label_html << template.pretty_format(object.public_send(method))
    end
  end
end
