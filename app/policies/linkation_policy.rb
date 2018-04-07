class LinkationPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return Directory.joins(:linkations).where('user_id' => user.id)
    end
  end
  # There is nothing tying a link to a user, only to a directory
  def index?
    return false
  end

  # A user should be allowed to see a single link
  def show?
    return true
  end

  # A user should be allowed to create a link
  def create?
    return true
  end

  # A user should be allowed to update a link
  def update?
    return true
  end

  # A user should be allowed to delete one of their own links
  def destroy?
    return true
  end

end
