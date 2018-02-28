Types::LinkationType = GraphQL::ObjectType.define do
  name 'Linkation'
  description 'An endpoint link'

  field :id, !types.ID

  # Parent
  field :directory, ->{ !Types::DirectoryType }

  # The links's name (not full path)
  field :name, !types.String

  # The destination link
  field :destination, !types.String

  # Timestamps
  field :created_at, ->{ !Types::DateTimeType }
  field :updated_at, ->{ !Types::DateTimeType }
end
