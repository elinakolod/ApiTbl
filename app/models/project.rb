require 'elasticsearch/model'

class Project < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user
  has_many :tasks, dependent: :destroy

  settings do
    mappings dynamic: false do
      indexes :name, type: :text, analyzer: :english
    end
  end
end
