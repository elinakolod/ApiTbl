module Types
  class MultiSearchType < Types::BaseObject
    field :searchable_id, ID, null: false
    field :searchable_type, String, null: false
    field :content, String, null: false
  end
end
