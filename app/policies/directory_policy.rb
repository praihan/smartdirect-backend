class DirectoryPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope.where(link_system: user.link_system)
    end
  end

  # A user should be allowed to see all their directories
  def index?
    return true
  end

  # A user should be allowed to see a single directory too
  def show?
    return true
  end

  # A user should be allowed to create a directory too
  def create?
    return true
  end
end