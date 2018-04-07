module UserGql
  class Schema < GraphQL::Schema
    query Types::QueryType
    # mutation Mutations::MutationType
  end
end
