# frozen_string_literal: true

# rubocop:disable all
class Business::PersonalizeController < ApplicationController
  def quiz
    if current_business
      pp = params['personalize']
      unless pp.nil?
        if Business::QUIZ.map(&:first).include? pp.keys.first.to_sym
          pp[pp.keys.first].reject!(&:empty?) if pp[pp.keys.first].class == Array
          current_business.update(pp.keys.first.to_sym => pp[pp.keys.first])
        end
      end
      current_question = 0
      quiz_copy = Business::QUIZ.dup
      quiz_copy -= %i[sec_or_crd already_covered annual_compliance] if current_business.business_stages.include? 'startup'
      quiz_copy.each_with_index do |q, i|
        current_question = i
        break if q[0] == :finish || current_business.send(q[0]).nil?
      end
      @question = quiz_copy[current_question]
      @question_id = current_question
      puts quiz_copy[current_question]
    end
  end
end
# rubocop:enable all
