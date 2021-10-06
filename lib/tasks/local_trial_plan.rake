# frozen_string_literal: true

desc 'Set local trial plan for business'
task assign_local_trial_plan_for_business: :environment do
  # ID - 307, Liberty Wealth Advisors, LLC
  # ID - 308, Portfolio Solutions
  # ID - 309, Counsel Fiduciary, LLC
  # ID - 299, Solitude Financial Services
  businesses = Business.where(id: [307, 308, 309, 299])

  businesses.each do |business|
    TrialPlanService.call(
      local: true,
      source: business,
      trial_end: 1_643_666_400,
      plan: 'business_tier_annual'
    )
  end
end

desc 'Set local trial plan for specialist'
task assign_local_trial_plan_for_specialist: :environment do
  specialists = Specialist.all

  specialists.each do |specialist|
    TrialPlanService.call(
      local: true,
      source: specialist,
      plan: 'specialist_pro',
      trial_end: 1_643_666_400
    )
  end
end
