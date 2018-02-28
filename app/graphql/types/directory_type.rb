Types::DirectoryType = GraphQL::ObjectType.define do
  name 'Directory'
  description 'A directory containing links and other directories'

  field :id, !types.ID

  # A directory only has one User owner at a time
  # See the model, for how this is retrieved
  field :user, ->{ !Types::UserType }

  # The directory's name (not full path)
  field :name, !types.String

  # Tree relations
  field :parent, ->{ Types::DirectoryType }
  field :children, ->{ !types[Types::DirectoryType] }
  field :ancestors, ->{ !types[Types::DirectoryType] }

  # Timestamps
  field :created_at, ->{ !Types::DateTimeType }
  field :updated_at, ->{ !Types::DateTimeType }
end
