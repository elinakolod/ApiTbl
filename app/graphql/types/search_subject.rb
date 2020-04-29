class Types::SearchSubject < Types::BaseUnion
  description 'Objects which may be searched'
  possible_types Types::ProjectType, Types::TaskType, Types::CommentType

  def self.resolve_type(object, _context)
    case object.class.name
    when 'Project'
      Types::ProjectType
    when 'Task'
      Types::TaskType
    when 'Comment'
      Types::CommentType
    end
  end
end
