# frozen_string_literal: true

class Specialists::PersonalizeController < ApplicationController
  before_action :require_specialist!
  before_action :set_business

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/LineLength
  # rubocop:disable Metrics/BlockNesting
  def quiz
    if current_specialist
      pp = params['personalize']
      unless pp.nil?
        if Business::QUIZ.map(&:first).include? pp.keys.first.to_sym
          pp[pp.keys.first].reject!(&:empty?) if pp[pp.keys.first].class == Array
          if pp.keys.first.to_sym == :aum
            @business.update(pp.keys.first.to_sym => fix_aum(pp[pp.keys.first]))
          else
            @business.update(pp.keys.first.to_sym => pp[pp.keys.first])
          end
        end
      end
      current_question = 0
      quiz_copy = Business::QUIZ.dup
      quiz_copy.delete_if { |s| %i[sec_or_crd already_covered annual_compliance].include? s[0] } if @business.business_stages.include? 'startup'
      quiz_copy.each_with_index do |q, i|
        current_question = i
        break if q[0] == :finish || @business.__send__(q[0]).nil?
      end
      @question = quiz_copy[current_question]
      @question_id = current_question
      @quiz_copy = quiz_copy
    end
    render 'business/personalize/quiz'
  end
  # rubocop:enable Metrics/BlockNesting
  # rubocop:enable Metrics/LineLength
  # rubocop:enable Metrics/AbcSize

  def book
    respond_to do |format|
      format.json do
        @business.update(onboard_call_booked: true)
        render json: { url: 'https://calendly.com/complect' }.to_json
      end
    end
  end

  private

  def fix_aum(str)
    vocab = [%w[BN bn Billion billion Bill bill], '000000000'], \
            [%w[Million million MM mm Mill mill], '000000']
    result = str.to_i.to_s
    occured = false
    vocab.each do |v|
      v[0].each do |word|
        if str.include?(word) && !occured
          result += v[1]
          occured = true
        end
      end
    end
    result.to_i
  end

  def set_business
    @business = current_specialist.manageable_ria_businesses.find_by(username: params[:business_id])
  end
end
