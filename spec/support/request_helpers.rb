# frozen_string_literal: true

module RequestHelper
  def json
    @json ||= JSON.parse(response.body)
    @json.is_a?(Hash) ? @json.with_indifferent_access : @json
  end
end
