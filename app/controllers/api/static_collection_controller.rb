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
                   "timezones": timezones_array }.to_json
  end
end
