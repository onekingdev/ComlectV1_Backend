# frozen_string_literal: true

require 'test_helper'

class Business::ProjectExtensionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business = create_business_with_valid_payment_source
    @specialist = create :specialist

    @project = create(
      :project_one_off_hourly,
      business: @business,
      specialist: @specialist
    )

    sign_in @business.user, 'password'
  end

  test 'creates pending extension request' do
    new_end_date = @project.ends_on + 1.week

    assert_difference 'ProjectExtension.count', +1 do
      post(
        business_project_extensions_path(@project),
        project_extension: { ends_on: new_end_date }
      )
    end
    assert @project.extensions.first.pending?
  end
end
