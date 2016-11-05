class Directory < ApplicationRecord

  # A directory can contains other directories as well as files
  # Deleting is recursive
  has_many :links, dependent: :destroy
  belongs_to :link_system

  # Get the current user through the owning LinkSystem
  delegate :user, to: :link_system

  # We can use Postgres' ltree here. Very fast, but limited to alphanumeric
  # characters. Also, avoids the complexity of nested structures in our code
  # (PG can do it for us :)
  ltree :path
end
