# frozen_string_literal: true

class Business::SpecialistsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :require_business!

  def index
    # render html: content_tag('business-marketplace-page', '',
    #                          ':industry-ids': Industry.all.map(&proc { |ind|
    #                                                               { id: ind.id,
    #                                                                 name: ind.name }
    #                                                             }).to_json,
    #                          ':jurisdiction-ids': Jurisdiction.all.map(&proc { |ind|
    #                                                                       { id: ind.id,
    #                                                                         name: ind.name }
    #                                                                     }).to_json,
    #                          ':sub-industry-ids': sub_industries(false).to_json,
    #                          ':states': State.fetch_all_usa.to_json).html_safe, layout: 'vue_business'

    render html: content_tag('main-layoyt', '',
                                 ':industry-ids': Industry.all.map(&proc { |ind|
                                                                      { id: ind.id,
                                                                        name: ind.name }
                                                                    }).to_json,
                                 ':jurisdiction-ids': Jurisdiction.all.map(&proc { |ind|
                                                                              { id: ind.id,
                                                                                name: ind.name }
                                                                            }).to_json,
                                 ':sub-industry-ids': sub_industries(false).to_json,
                                 ':states': State.fetch_all_usa.to_json).html_safe, layout: 'vue_main_layout'
  end
end
