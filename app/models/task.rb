class Task < ApplicationRecord
  belongs_to :project

  has_many :comments
end
