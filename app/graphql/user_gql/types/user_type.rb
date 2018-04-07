module UserGql::Types
  class UserType < BaseObject
    description 'A user of the application'

    field :id, ID, null: false

    # These are the two parts of @model.identifiable_claim
    # See models/user.rb
    field :oauth_provider, String, null: false
    field :oauth_id, String, null: false

    # These are just general info about the user
    field :name, String, null: false
    field :email, String, null: false

    # This is also an identifiable (unique) attribute of the user
    field :friendly_name, String, null: false

    # The ROOT directory of the user
    field :directory, DirectoryType, null: false

    # Timestamps
    field :created_at, DateTimeType, null: false
    field :updated_at, DateTimeType, null: false
  end
end
