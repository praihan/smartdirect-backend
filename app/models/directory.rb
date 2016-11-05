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

  # See settings.yml for explanation
  validates_format_of :path, with: /#{Settings[:postgres][:ltree_label_regex]}/

  def full_path
    # Since PG's ltree uses '.' as separators, we have to change
    # them to '/' because that's how everyone else does it.
    # Also, strip the ROOT directory from the beginning, that's just
    # an implementation detail.
    root_name = Settings[:default_root_directory_name]
    canonical_full_path = path.gsub '.', '/'
    return canonical_full_path[root_name.length + 1 .. -1]
  end

  def full_path=(val)
    val = val.to_s
    # TODO: Make sure there aren't any '.'
    root_name = Settings[:default_root_directory_name]
    postgres_ltree_style_path = val.gsub '/', '.'
    self.path = "#{root_name}.#{postgres_ltree_style_path}"
  end
end
