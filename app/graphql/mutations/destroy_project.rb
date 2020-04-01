module Mutations
  class DestroyProject < BaseMutation
    argument :id, ID, required: true

    field :project_id, ID, null: true
    field :errors, [String], null: false

    def resolve(id:)
      result = ::Api::V1::Projects::Operation::Destroy.call(params: { id: id })
      if result.success?
        {
          project_id: id,
          errors: []
        }
      elsif result.failure? && result[:model].blank?
        {
          project_id: nil,
          errors: ['Doesn\'t exist']
        }
      end
    end
  end
end
