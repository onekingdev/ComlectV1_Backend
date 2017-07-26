# frozen_string_literal: true

ActiveAdmin.register_page 'Transaction::OneOff' do
  belongs_to :project

  page_action :create, method: :post do
    return if params['project_id'].blank?
    amount_in_cents = (BigDecimal.new(params['amount']) * 100).to_i
    fee_in_cents = amount_in_cents * Charge::COMPLECT_FEE_PCT
    total_with_fee_in_cents = amount_in_cents + fee_in_cents

    Transaction::OneOff.create!(
      project_id: params['project_id'],
      amount_in_cents: total_with_fee_in_cents,
      fee_in_cents: fee_in_cents * 2, # 10% from business and specialist
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
