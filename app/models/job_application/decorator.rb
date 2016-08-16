# frozen_string_literal: true
class JobApplication::Decorator < Draper::Decorator
  decorates JobApplication
  delegate_all
end
