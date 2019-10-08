
class TaskPolicy < ApplicationPolicy
  def user_has_access?
    record.project.user_id == user.id
  end

  def index?
    record.user_id == user.id
  end

  alias move_lower? user_has_access?
  alias move_higher? user_has_access?
  alias create? user_has_access?
  alias update? user_has_access?
  alias destroy? user_has_access?
end
