class Project < ApplicationRecord
  include PgSearch::Model

  # Searching through associations
  pg_search_scope :search_by_task, associated_against: { tasks: :name }

  belongs_to :user
  has_many :tasks, dependent: :destroy
end
