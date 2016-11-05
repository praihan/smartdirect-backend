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

  def index?
    return true
  end

  def show?
    return true
  end
end