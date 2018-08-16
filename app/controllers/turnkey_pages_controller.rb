# frozen_string_literal: true

class TurnkeyPagesController < ApplicationController
  def index
    @categories = TurnkeyPage.all.order(:id)
  end

  def show
    @states = ['Alabama', 'Alaska', 'Arizona',\
               'Arkansas', 'California', 'Colorado',\
               'Connecticut', 'Delaware', 'Florida',\
               'Georgia', 'Hawaii', 'Idaho', 'Illinois',\
               'Indiana', 'Iowa', 'Kansas', 'Kentucky',\
               'Louisiana', 'Maine', 'Maryland', 'Massachusetts',\
               'Michigan', 'Minnesota', 'Mississippi', 'Missouri',\
               'Montana', 'Nebraska', 'Nevada', 'New Hampshire',\
               'New Jersey', 'New Mexico', 'New York',\
               'North Carolina', 'North Dakota', 'Ohio',\
               'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island',\
               'South Carolina', 'South Dakota',\
               'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia',\
               'Washington', 'West Virginia', 'Wisconsin', 'Wyoming']

    @bds = [['EMC', 0], ['BIA', 1], ['MFU', 2], ['MSD', 1], ['TAS', 1], ['SSL', 1],\
            ['EMF', 0], ['NEX', 1], ['MFR', 2], ['MSB', 1], ['PLA', 1], ['IAD', 1],\
            ['IDM', 0], ['BDD', 1], ['VLA', 1], ['OGI', 1], ['PCB', 2], ['MRI', 1],\
            ['TRA', 0], ['USG', 2], ['GSD', 1], ['NPB', 2], ['BNA', 2], ['OTH', 2],\
            ['BDR', 2], ['RES', 1], ['GSB', 1], ['TAP', 1], ['INA', 2], ['LP', 3]]

    @turnkey_page = TurnkeyPage.find_by(url: params[:id])
  end

  def create
    @solution = TurnkeySolution.find(params[:solution][:id])
    @missing = @solution.validate_params(params[:solution])
    render layout: false
  end

  def update
    if current_business && current_user.payment_info?
      project_from_params(params[:solution]).save! if params.include? :solution
    end
    render layout: false
  end

  def new
    @project = Project::Form.copy(project_from_params(params[:solution]))
    render 'business/projects/new'
  end

  private

  def project_from_params(params_solution)
    solution = TurnkeySolution.find(params_solution[:id])
    if solution.validate_params(params_solution)
      template = if solution.flavored? && params_solution.include?(:flavor)
                   solution.project_templates.where(flavor: params_solution[:flavor]).first
                 else
                   solution.project_templates.first
                 end
      Project.new.build_from_template(current_business.id, template, params_solution)
    else
      Project.new
    end
  end
end
