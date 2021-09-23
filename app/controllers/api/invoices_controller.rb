# frozen_string_literal: true

class Api::InvoicesController < ApiController
  before_action :require_someone!

  def index
    invoices = @current_someone.invoices
    respond_with invoices, each_serializer: InvoiceSerializer
  end
end
