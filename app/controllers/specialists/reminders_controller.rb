# frozen_string_literal: true

class Specialists::RemindersController < ApplicationController
  include RemindersUpdater
  include ActionView::Helpers::TagHelper

  before_action :require_specialist!

  def index
    respond_to do |format|
      format.html do
        render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_specialist_layout'
      end
    end
  end
end
