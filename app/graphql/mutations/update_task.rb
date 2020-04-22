module Mutations
  class UpdateTask < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: true
    argument :done, Boolean, required: true

    field :task, Types::TaskType, null: true
    field :errors, [String], null: false

    def resolve(id:, name:, done:)
      result = ::Api::V1::Tasks::Operation::Update.call(params: { id: id, name: name, done: done},
                                                        current_user: context[:current_user])
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
