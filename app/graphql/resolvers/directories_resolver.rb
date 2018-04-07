module Resolvers
  class DirectoriesResolver < GraphQL::Function
    description "All directories for current user"

    type !types[Types::DirectoryType]

    def call(scope, _args, _ctx)
      scope
    end
  end
end