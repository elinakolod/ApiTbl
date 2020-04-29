require 'elasticsearch/model'

class Comment < ApplicationRecord
  include Elasticsearch::Model

  after_save    { IndexerJob.perform_now(operation: :index, record_id: self.id, record_class: self.class) }
  after_destroy { IndexerJob.perform_now(operation: :delete, record_id: self.id, record_class: self.class) }

  settings do
    mappings dynamic: false do
      indexes :body, type: :text
    end
  end

  belongs_to :task
end
