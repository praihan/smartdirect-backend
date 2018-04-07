Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  field :me, !Types::UserType do
    resolve ->(_obj, _args, ctx) { ctx[:current_user] }
  end

  field :directory, function: Resolvers::DirectoryResolver.new do
    authorize! :show, policy: Directory
    before_scope DirectoryPolicy
  end

  field :directories, function: Resolvers::DirectoriesResolver.new do
    authorize! :index, policy: Directory
    before_scope DirectoryPolicy
  end
end
