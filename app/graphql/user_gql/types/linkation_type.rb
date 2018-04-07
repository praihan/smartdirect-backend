module UserGql::Types
  class LinkationType < BaseObject
    description 'An endpoint link'

    field :id, ID, null: false

    # Parent
    field :directory, DirectoryType, null: false

    # The links's name (not full path)
    field :name, String, null: false

    # The destination link
    field :destination, String, null: false

    # Timestamps
    field :created_at, DateTimeType, null: false
    field :updated_at, DateTimeType, null: false
  end
end
