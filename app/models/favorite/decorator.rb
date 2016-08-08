# frozen_string_literal: true
class Favorite::Decorator < ApplicationDecorator
  decorates Favorite
  delegate_all
end
