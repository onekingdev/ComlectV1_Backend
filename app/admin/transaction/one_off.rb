# frozen_string_literal: true

ActiveAdmin.register_page 'Transaction::OneOff' do
  belongs_to :project

  page_action :create, method: :post do
    return if params['project_id'].blank?

    # project = Project.find(params['project_id'])
    # business = project.business
    # specialist = project.specialist

    amount_in_cents = (BigDecimal(params['amount']) * 100).to_i
    business_fee_in_cents = amount_in_cents # * business.rewards_tier.fee_percentage
    specialist_fee_in_cents = amount_in_cents # * specialist.rewards_tier.fee_percentage
    total_fees_in_cents = business_fee_in_cents + specialist_fee_in_cents
    total_with_fee_in_cents = amount_in_cents + business_fee_in_cents

    Transaction::OneOff.create!(
      project_id: params['project_id'],
      description: params['description'],
      amount_in_cents: total_with_fee_in_cents,
      fee_in_cents: total_fees_in_cents,
      date: Time.zone.now
    )

    redirect_to admin_transactions_path
  end

  content title: 'New One-off Transaction' do
    form action: admin_project_transaction_oneoff_create_path, method: :post do
      input type: :hidden, name: 'authenticity_token', value: form_authenticity_token

      fieldset(class: 'inputs') do
        ol do
          li do
            label 'Description'
            input name: :description, type: :text
          end
        end

        ol do
          li do
            label 'Amount (ex: 501.43)'
            input name: :amount, type: :text
          end
        end
      end

      fieldset(class: 'actions') do
        ol do
          li action: 'action input_action' do
            input type: :submit
          end

          li class: 'cancel' do
            a(href: admin_project_path(params['project_id'])) { 'Cancel' }
          end
        end
      end
    end
  end
end
