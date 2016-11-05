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

  # See https://www.postgresql.org/docs/9.1/static/ltree.html
  # ltree only accepts alphanumeric characters and underscore.
  validates_format_of :path, with: /\A[A-Za-z0-9_]+\z/
end
