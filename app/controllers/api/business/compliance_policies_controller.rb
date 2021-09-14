# frozen_string_literal: true

class Api::Business::CompliancePoliciesController < ApiController
  before_action :require_business!
  before_action { authorize_action(Roles::CompliancePolicyPolicy) }
  before_action { authorize_business_tier(Business::CompliancePolicyPolicy) }
  before_action :find_cpolicy, only: %i[publish show update download destroy]
  skip_before_action :verify_authenticity_token # TODO: proper authentication
  before_action :default_configuration
  before_action :find_combined_policy, only: %i[download download_all combined_policy]

  def index
    cpolicies = if current_user.specialist&.role_basic?(current_business)
      current_business.compliance_policies.root_published.order('position desc')
    else
      current_business.compliance_policies.root.order('position desc')
    end
    respond_with cpolicies, each_serializer: CompliancePolicySerializer
  end

  def download
    @cpolicy = @cpolicy.versions.first if @cpolicy.draft? && @cpolicy.untouched
    if current_business.compliance_policies.root_published.collect(&:id).include?(@cpolicy.id)
      @combined_policy_db.update(file_data: nil)
      @cpolicy.update(pdf_data: nil)
      PdfCompliancePolicyWorker.perform_async(@cpolicy.id, false)
    elsif @cpolicy.pdf.nil?
      PdfCompliancePolicyWorker.perform_async(@cpolicy.id, true)
    end
    respond_with status: :ok
  end

  def combined_policy
    respond_with @combined_policy_db, serializer: CombinedPolicySerializer
  end

  def show
    respond_with @cpolicy, serializer: CompliancePolicySerializer
  end

  def download_all
    @combined_policy_db.update(file_data: nil)
    PdfCompliancePolicyWorker.perform_async(current_business.compliance_policies.first.id, false)
    respond_with status: :ok
  end

  def destroy
    if @cpolicy.destroy
      respond_with @cpolicy, serializer: CompliancePolicySerializer
    else
      head :bad_request
    end
  end

  def create
    cpolicy = current_business.compliance_policies.create(cpolicy_params.merge(untouched: false, edited_at: Time.now.in_time_zone(current_business.time_zone)))
    if cpolicy.errors.any?
      respond_with errors: cpolicy.errors, status: :unprocessable_entity
    else
      respond_with cpolicy, serializer: CompliancePolicySerializer
    end
  end

  def publish
    if @cpolicy.src_id.nil?
      draft_cpolicy = @cpolicy.dup
      draft_cpolicy.untouched = true
      draft_cpolicy.save
      @cpolicy.published_versions.update_all(src_id: draft_cpolicy.id, status: 'published')
      @cpolicy.update(status: 'published',
                      src_id: draft_cpolicy.id,
                      published_by: (current_user.specialist ? current_user.specialist.name : current_business.name),
                      edited_at: Time.now.in_time_zone(current_business.time_zone))
      respond_with draft_cpolicy, serializer: CompliancePolicySerializer
    else
      head :bad_request
    end
  end

  def update
    return respond_with error: 'Cannot edit published policy' if @cpolicy.published? && params[:archived].nil?
    return respond_with error: 'Cannot edit archived policy' if @cpolicy.archived? && params[:archived].nil?

    if @cpolicy.update(cpolicy_params.merge(untouched: false, edited_at: Time.now.in_time_zone(current_business.time_zone)))
      respond_with @cpolicy, serializer: CompliancePolicySerializer
    else
      respond_with errors: @cpolicy.errors, status: :unprocessable_entity
    end
  end

  def update_position
    if params[:positions].present?
      params[:positions].each do |item|
        policy = current_business.compliance_policies.find_by(id: item['id'])
        policy&.update_attribute('position', item['position'])
      end
      respond_with status: :ok
    else
      respond_with status: :unprocessable_entity
    end
  end

  private

  def default_configuration
    @cpconf = current_business.compliance_policy_configuration.presence ||
              CompliancePolicyConfiguration.create_default(current_business.id)
  end

  def find_combined_policy
    @combined_policy_db = current_business.combined_policy.presence ||
                          CombinedPolicy.create(business_id: current_business.id)
  end

  def cpolicy_params
    params.permit(
      :name,
      :description,
      :position,
      :archived,
      sections: [
        :title, :description, children: [
          :title, :description, children: [
            :title, :description, children: [
              :title, :description, children: [
                :title, :description, children: [
                  :title, :description, children: [
                    :title, :description, children: [
                      :title, :description, children: []
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    )
  end

  def find_cpolicy
    @cpolicy = current_business.compliance_policies.find(params[:id])
    @cpolicy = nil if !@cpolicy.published? && current_user.specialist&.role_basic?(current_business)
  end
end
