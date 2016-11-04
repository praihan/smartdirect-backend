class LinkDirectory < ApplicationRecord

  # A directory can contains other directories as well as files
  # Deleting is recursive
  has_many :links, dependent: :destroy

  # We can use Postgres' ltree here. Very fast, but limited to alphanumeric
  # characters. Also, avoids the complexity of nested structures in our code
  # (PG can do it for us :)
  ltree :path
end
