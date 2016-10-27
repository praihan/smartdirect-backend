class UserPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      return scope.where(id: user.id)
    end
  end

  # A user must have been authenticated to get here.
  # They are always allowed to see their own information.
  def index?
    return true
  end

  # Since we limit the scope, we ca always allow this.
  # The user will get a 404 instead of a 403 if they don't have access or user doesn't exist
  def show?
    return true
  end
end
