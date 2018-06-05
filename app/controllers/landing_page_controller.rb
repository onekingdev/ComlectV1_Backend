# frozen_string_literal: true

class LandingPageController < ApplicationController
  def show
    freg_cnt = Specialist.where(:former_regulator => true).count
    @former_regulators_percent = 100
    @former_regulators_percent = freg_cnt*100/Specialist.count if freg_cnt != 0
Specialist.count
    years_of_xp = Specialist.join_experience.all.where(work_experiences: { compliance: true }).collect(&:years_of_experience)
    @avg_xp_years = years_of_xp.sum/years_of_xp.count
    respond_to :html
  end
end