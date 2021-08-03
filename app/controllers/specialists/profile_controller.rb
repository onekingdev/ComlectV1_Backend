# frozen_string_literal: true

class Specialists::ProfileController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :require_specialist!

  # def show
  #   @user = current_user
  # end

  # def show
  #   render html: content_tag('specialist-profile-page', '').html_safe, layout: 'vue_specialist'
  # end

  def show
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_specialist_layout'
  end
end
