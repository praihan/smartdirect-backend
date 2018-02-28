SmartdirectSchema = GraphQL::Schema.define do
  instrument(:field, GraphQL::Pundit::Instrumenter.new)

  query(Types::QueryType)
end
