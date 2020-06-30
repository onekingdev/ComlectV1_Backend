# frozen_string_literal: true

class AnnualReport < ActiveRecord::Base
  belongs_to :business
  has_many :annual_review_employees, dependent: :destroy
  has_many :regulatory_changes, dependent: :destroy
  has_many :business_changes, dependent: :destroy
  has_many :findings, dependent: :destroy
  accepts_nested_attributes_for :annual_review_employees, allow_destroy: true
  accepts_nested_attributes_for :regulatory_changes, allow_destroy: true
  accepts_nested_attributes_for :business_changes, allow_destroy: true
  accepts_nested_attributes_for :findings, allow_destroy: true
  # after_save :destroy_empties
  include PdfUploader[:pdf]

  def cof_str
    if cof_bits.nil?
      '0000000000000000000000000000000000'
    else
      cof_bits.to_s(2).rjust(34, '0').reverse
    end
  end

  def findings_report
    total_topics = ComplianceCategory.all.collect(&:checkboxes_arr).collect(&:keys).flatten.count
    failed_topics = 0
    unfailed_topics = {}
    ind = 0
    ComplianceCategory.all.find_each do |compliance_category|
      @checkboxes_arr = compliance_category.checkboxes_arr
      compliance_category.checkboxes_arr.keys.each do |cb_key|
        cb_ind = 0
        failed_topic = false
        findings.each do |finding|
          if (finding.compliance_category == compliance_category.id) && (finding.checkbox_index == @checkboxes_arr.keys.index(cb_key))
            failed_topic = true if finding.finding.present?
            unless @checkboxes_arr[cb_key][cb_ind].nil?
              @checkboxes_arr[cb_key][cb_ind] = nil
              ind += 1
              cb_ind += 1
            end
          end
          @checkboxes_arr[cb_key].each do |cb|
            unless cb.nil?
              ind += 1
              cb_ind += 1
            end
          end
        end
        if failed_topic
          failed_topics += 1
        else
          unfailed_topics[compliance_category.id] = [] if unfailed_topics[compliance_category].nil?
          unfailed_topics[compliance_category.id].push(cb_key)
        end
      end
    end
    { percentage: failed_topics * 100 / total_topics, unfailed_topics: unfailed_topics }
  end

  def score
    100
    # max_score = cof_str.length
    # cur_score = cof_str.split('').map(&:to_i).inject(0) { |sum, x| sum + x }
    # (cur_score * 100 / max_score).to_i
  end

  def ready?
    result = true
    %i[review_start review_end tailored_lvl].each do |a|
      result = false if public_send(a).nil?
    end
    if score == 100 && result
      result
    else
      false
    end
  end
end
