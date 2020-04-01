module Mutations
  class DestroyTask < BaseMutation
    argument :id, ID, required: true

    field :task_id, ID, null: true
    field :errors, [String], null: false

    def resolve(id:)
      result = ::Api::V1::Tasks::Operation::Destroy.call(params: { id: id })
      if result.success?
        {
          task_id: id,
          errors: []
        }
      elsif result.failure? && result[:model].blank?
        {
          task_id: nil,
          errors: ['Doesn\'t exist']
        }
      end
    end
  end
end
