# frozen_string_literal: true

class Api::Business::InvoicesController < ApiController
  before_action :require_business!

  def index
    invoices = current_business.invoices
    respond_with invoices, each_serializer: InvoiceSerializer
  end
end
