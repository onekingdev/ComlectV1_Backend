# frozen_string_literal: true

class ExamsController < ApplicationController
  include ActionView::Helpers::TagHelper

  def show
    render html: content_tag('auth-layout', '').html_safe, layout: 'vue_onboarding'
  end
end
