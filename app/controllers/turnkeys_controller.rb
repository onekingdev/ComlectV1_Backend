class TurnkeysController < ApplicationController
  PAGES = %w[
    hourly-advice
    mock-sec-exam
    finra-sec-state-nfa
    tailored-compliance-manual
    outsourced-compliance-program
    topical-turnkey-solutions
  ].freeze

  def index
  end

  def page
    return render_404 unless PAGES.include?(params[:page])
    render params[:page]
  end
end