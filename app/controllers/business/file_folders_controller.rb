# frozen_string_literal: true

class Business::FileFoldersController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :require_business!

  def index
    render html: content_tag('business-file-folders-page', ''), layout: 'vue_business'
  end

  def show
    render html: content_tag('business-file-folders-page', ''), layout: 'vue_business'
  end
end
