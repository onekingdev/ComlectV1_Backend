# frozen_string_literal: true

# rubocop:disable all
class Business::PersonalizeController < ApplicationController
  def quiz
    if current_business
      pp = params['personalize']
      unless pp.nil?
        if Business::QUIZ.map(&:first).include? pp.keys.first.to_sym
          pp[pp.keys.first].reject!(&:empty?) if pp[pp.keys.first].class == Array
          if pp.keys.first.to_sym == :aum
            current_business.update(pp.keys.first.to_sym => fix_aum(pp[pp.keys.first]))
          else
            current_business.update(pp.keys.first.to_sym => pp[pp.keys.first])
          end
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
end
# rubocop:enable all
