# frozen_string_literal: true

class ApiResponder < ::ActionController::Responder
  def api_behavior
    raise MissingRenderer, format unless has_renderer?
    answer = resource.try(:to_model) || resource
    if get?
      display answer
    elsif post?
      display answer, status: :created
    else
      display answer
    end
  end
end
