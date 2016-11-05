class DirectoryPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope.where(id: user.link_system.id)
    end
  end

  def index?
    return true
  end

  def show?
    return true
  end
end