module Mutations
  class CreateComment < BaseMutation
    argument :body, String, required: true
    argument :task_id, ID, required: true

    field :comment, Types::CommentType, null: true
    field :errors, [String], null: false

    def resolve(body:, task_id:)
      result = ::Api::V1::Comments::Operation::Create.call(params: { body: body, task_id: task_id},
                                                           current_user: context[:current_user])
      if result.success?
        {
          comment: result[:model],
          errors: []
        }
      elsif result.failure?
        {
          errors: result['contract.default'].errors.messages
        }
      end
    end
  end
end
