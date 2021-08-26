# frozen_string_literal: true

class Api::Business::CompliancePoliciesController < ApiController
  before_action :require_business!
  before_action { authorize_action(Roles::CompliancePolicyPolicy) }
  before_action { authorize_business_tier(Business::CompliancePolicyPolicy) }
  before_action :find_cpolicy, only: %i[publish show update download destroy]
  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    respond_with current_business.compliance_policies.root,
                 each_serializer: CompliancePolicySerializer
  end

  def download
    pdf = render_to_string pdf: "Policy #{@cpolicy.name}.pdf",
                           template: 'business/compliance_policies/compliance_policy.pdf.erb',
                           encoding: 'UTF-8',
                           locals: { cpolicy: @cpolicy },
                           margin: { top:               0,
                                     bottom:            0,
                                     left:              0,
                                     right:             0 }
    uploader = PdfUploader.new(:store)
    file = Tempfile.new(["cpolicy_#{@cpolicy.id}", '.pdf'])
    file.binmode
    file.write(pdf)
    file.rewind
    uploaded_file = uploader.upload(file)
    @cpolicy.update(pdf_data: uploaded_file.to_json)
    redirect_to @cpolicy.pdf_url
  end

  def show
    respond_with @cpolicy, serializer: CompliancePolicySerializer
  end

  def destroy
    if @cpolicy.archived && @cpolicy.destroy
      respond_with @cpolicy, serializer: CompliancePolicySerializer
    else
      head :bad_request
    end
  end

  def create
    cpolicy = current_business.compliance_policies.create(cpolicy_params)
    if cpolicy.errors.any?
      respond_with errors: cpolicy.errors, status: :unprocessable_entity
    else
      respond_with cpolicy, serializer: CompliancePolicySerializer
    end
  end

  def publish
    if @cpolicy.src_id.nil?
      draft_cpolicy = @cpolicy.dup
      draft_cpolicy.save
      @cpolicy.versions.update_all(src_id: draft_cpolicy.id)
      @cpolicy.update(status: 'published', src_id: draft_cpolicy.id)
      respond_with draft_cpolicy, serializer: CompliancePolicySerializer
    else
      head :bad_request
    end
  end

  def update
    if @cpolicy.update(cpolicy_params)
      respond_with @cpolicy, serializer: CompliancePolicySerializer
    else
      respond_with errors: @cpolicy.errors, status: :unprocessable_entity
    end
  end

  private

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
  end
end
