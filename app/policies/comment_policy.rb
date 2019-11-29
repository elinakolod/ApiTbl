class CommentPolicy < ApplicationPolicy
  def user_has_access?
    record.task.project.user_id == user.id
  end

  alias create? user_has_access?
  alias destroy? user_has_access?
end
