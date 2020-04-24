class Task < ApplicationRecord
  include PgSearch::Model

  multisearchable against: [:name], update_if: :name_changed?

  belongs_to :project
  has_many :comments, dependent: :destroy
end
