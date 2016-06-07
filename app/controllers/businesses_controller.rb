# frozen_string_literal: true
class BusinessesController < ApplicationController
  def show
    present Business::Show
  end

  def new
    form Business::Create
  end

  def create
    run Business::Create do |op|
      return redirect_to business_path(op.model)
    end

    render :new
  end
end
