class DirectoryPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope || Directory
    end

    def resolve
      return scope.where(user: user)
    end
  end

  # A user should be allowed to see all their directories
  def index?
    return true
  end

  # A user should be allowed to see a single directory
  def show?
    return true
  end

  # A user should be allowed to create a directory
  def create?
    return true
  end

  # A user should be allowed to update a directory
  def update?
    return true
  end

  # A user should be allowed to delete one of their own directories
  def destroy?
    return true
  end
end
