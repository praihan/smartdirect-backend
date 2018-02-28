Types::UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'A user of the application'

  field :id, !types.ID

  # These are the two parts of @model.identifiable_claim
  # See models/user.rb
  field :oauth_provider, !types.String
  field :oauth_id, !types.String

  # These are just general info about the user
  field :name, !types.String
  field :email, !types.String

  # This is also an identifiable (unique) attribute of the user
  field :friendly_name, !types.String

  # The ROOT directory of the user
  field :directory, ->{ !Types::DirectoryType }

  # Timestamps
  field :created_at, ->{ !Types::DateTimeType }
  field :updated_at, ->{ !Types::DateTimeType }
end