# frozen_string_literal: true

class ExamsController < ApplicationController
  include ActionView::Helpers::TagHelper

  def show
    exam = Exam.find_by(share_uuid: params[:uuid])
    if exam.present?
      render html: content_tag('exam-management-auditor-portal', '',
                               ':exam-uuid': "'#{exam.share_uuid}'").html_safe, layout: 'vue_onboarding'
    else
      render status: :not_found
    end
  end
end
