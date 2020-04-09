module Mutations
  class CreateProject < BaseMutation
    argument :name, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: false

    def resolve(name:)
      result = ::Api::V1::Projects::Operation::Create.call(params: { name: name}, current_user: context[:current_user])
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
