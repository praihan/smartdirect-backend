Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  field :me, !Types::UserType do
    resolve ->(_obj, _args, ctx) { ctx[:current_user] }
  end

  field :directory, Types::DirectoryType do
    argument :id, !types.ID
    authorize! :show, policy: Directory
    before_scope DirectoryPolicy
    resolve ->(scope, args, _ctx) do
      scope.find_by_id args[:id]
    end
  end
end
