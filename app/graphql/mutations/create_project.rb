module Mutations
  class CreateProject < BaseMutation
    argument :name, String, required: true
    argument :user_id, ID, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: false

    def resolve(name:, user_id:)
      result = ::Api::V1::Projects::Operation::Create.call(params: { name: name}, current_user: User.find(user_id))
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
