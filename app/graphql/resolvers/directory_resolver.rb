module Resolvers
  class DirectoryResolver < GraphQL::Function
    argument :id, !types.ID

    description "Directory by ID"

    type Types::DirectoryType

    def call(scope, args, _ctx)
      scope.find_by_id args[:id]
    end
  end
end