class Task < ApplicationRecord
  include PgSearch::Model

  # Full Text Search
  pg_search_scope :search_name_by_prefix, against: :name, using: { tsearch: { prefix: true } }
  pg_search_scope :stemming_search, against: :name, using: { tsearch: { dictionary: 'english' } }
  pg_search_scope :name_filter, against: :name, using: { tsearch: { negation: true } }

  belongs_to :project

  has_many :comments, dependent: :destroy
end
