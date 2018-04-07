SMARTDIRECT_SCHEMA = GraphQL::Schema.define do
  instrument(:field, GraphQL::Pundit::Instrumenter.new)

  query Types::QueryType
  mutation Mutations::MutationType
end
