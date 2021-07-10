# frozen_string_literal: true

module Project::PgSearchConfig
  extend ActiveSupport::Concern

  included do
    include PgSearch::Model
    pg_search_scope :search,
                    against: %i[title description],
                    using: {
                      tsearch: {
                        dictionary: 'english',
                        tsvector_column: 'tsv'
                      }
                    }
  end
end
