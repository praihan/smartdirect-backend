module UserGql::Types
  class QueryType < BaseObject
    description 'Root query'

    field :me, UserType, null: false

    # field :directory, function: Resolvers::DirectoryResolver.new do
    #   authorize! :show, policy: Directory
    #   before_scope DirectoryPolicy
    # end
    #
    # field :directories, function: Resolvers::DirectoriesResolver.new do
    #   authorize! :index, policy: Directory
    #   before_scope DirectoryPolicy
    # end

    # field :directory, function: Resolvers::DirectoryResolver.new
    # field :directories, function: Resolvers::DirectoriesResolver.new

    def me
      context[:current_user]
    end
  end
end
