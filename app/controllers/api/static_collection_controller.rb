# frozen_string_literal: true

class Api::StaticCollectionController < ApiController
  def index
    render json: { "jurisdictions": Jurisdiction.all.map(&proc { |ind|
                                                            { id: ind.id,
                                                              name: ind.name }
                                                          }),
                   "industries": Industry.all.map(&proc { |ind|
                                                     { id: ind.id,
                                                       name: ind.name }
                                                   }),
                   "sub_industries_business": sub_industries(false),
                   "sub_industries_specialist": sub_industries(true),
                   "states": State.fetch_all_usa,
                   "countries": ISO3166::Country.all.collect(&:name),
                   "timezones": timezones_array,
                   "STRIPE_PUBLISHABLE_KEY": ENV.fetch('STRIPE_PUBLISHABLE_KEY') }.to_json
  end
end
