module Mutations
  class DestroyComment < BaseMutation
    argument :id, ID, required: true

    field :comment_id, ID, null: true
    field :errors, [String], null: false

    def resolve(id:)
      result = ::Api::V1::Comments::Operation::Destroy.call(params: { id: id }, current_user: context[:current_user])
      if result.success?
        {
          comment_id: id,
          errors: []
        }
      elsif result.failure? && result[:model].blank?
        {
          errors: ['Doesn\'t exist']
        }
      end
    end
  end
end
