module UserGql::Types
  class DirectoryType < BaseObject
    description 'A directory containing links and other directories'

    field :id, ID, null: false

    # A directory only has one User owner at a time
    # See the model, for how this is retrieved
    field :user, UserType, null: false

    # The directory's name (not full path)
    field :name, String, null: false

    # Tree relations
    field :parent, DirectoryType, null: true
    field :children, [DirectoryType], null: false
    field :ancestors, [DirectoryType], null: false

    field :descendant, DirectoryType, null: true do
      argument :path, String, required: true
    end

    # Contained links
    field :linkations, [LinkationType], null: false

    # Timestamps
    field :created_at, DateTimeType, null: false
    field :updated_at, DateTimeType, null: false

    def descendant(path:)
      directory = object
      directory.find_by_path path
    end
  end
end
