# frozen_string_literal: true
require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase
  test 'toggle favorite' do
    business = create :business
    specialist = create :specialist
    params = { favorited_type: specialist.class.name, favorited_id: specialist.id }
    assert_difference 'Favorite.count', +1 do
      Favorite.toggle! business, params
    end
    assert_difference 'Favorite.count', -1 do
      Favorite.toggle! business, params
    end
  end
end
