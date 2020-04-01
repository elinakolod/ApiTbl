module Mutations
  class UpdateProject < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: false

    def resolve(id:, name:)
      result = ::Api::V1::Projects::Operation::Update.call(params: { id: id, name: name})
      if result.success?
        {
          project: result[:model],
          errors: []
        }
      elsif result.failure?
        {
          project: nil,
          errors: result['contract.default'].errors.messages
        }
      end
    end
  end
end
