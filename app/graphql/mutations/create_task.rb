module Mutations
  class CreateTask < BaseMutation
    argument :name, String, required: true
    argument :project_id, ID, required: true

    field :task, Types::TaskType, null: true
    field :errors, [String], null: false

    def resolve(name:, project_id:)
      result = ::Api::V1::Tasks::Operation::Create.call(params: { name: name, project_id: project_id})
      if result.success?
        {
          task: result[:model],
          errors: []
        }
      elsif result.failure?
        {
          task: nil,
          errors: result['contract.default'].errors.messages
        }
      end
    end
  end
end
